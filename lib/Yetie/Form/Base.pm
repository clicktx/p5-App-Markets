package Yetie::Form::Base;
use Mojo::Base -base;
use Carp qw(croak);
use CGI::Expand qw/expand_hash/;
use Scalar::Util qw(blessed);
use Mojo::Collection qw(c);
use Mojolicious::Controller;
use Yetie::Util qw(load_class);
use Yetie::Parameters;
use Yetie::Form::TagHelpers;

has controller => sub { Mojolicious::Controller->new };
has 'fieldset';
has is_validated => '0';
has name_space   => 'Yetie::Form::FieldSet';
has tag_helpers  => sub { Yetie::Form::TagHelpers->new( shift->controller ) };

sub field { shift->fieldset->field(@_) }

sub fill_in {
    my ( $self, $entity ) = @_;

    my @names = $self->fieldset->field_keys;
    foreach my $name (@names) {
        next unless $entity->can($name);

        my $field = $self->fieldset->field($name);
        my $value = $entity->$name;
        next unless defined $value;

        if ( ref $value eq 'ARRAY' ) {
            _fill_field( $field, $_ ) for @{$value};
        }
        elsif ( !ref $value ) {
            _fill_field( $field, $value );
        }
        else {
            die 'Illegal type: ' . ref $value;
        }
    }
    return $self;
}

sub new {
    my ( $class, $ns ) = ( shift, shift );

    my $self = $class->SUPER::new(@_);
    $self->fieldset( $self->_fieldset($ns) );
    return $self;
}

sub has_data { shift->validation->has_data }

sub param {
    my ( $self, $key ) = @_;
    $key =~ m/\[\]$/ ? $self->params->every_param($key) : $self->params->param($key);
}

sub params {
    my $self = shift;
    croak 'do not call "validate" method' unless $self->is_validated;
    return $self->{_validated_parameters} if $self->{_validated_parameters};

    my $v      = $self->validation;
    my %output = %{ $v->output };

    # NOTE: scope parameterは別に保存していないので
    # 'user.name' フィールドを使う場合は 'user'フィールドを使うことが出来ない
    my $expand_hash = expand_hash( \%output );
    %output = ( %output, %{$expand_hash} );

    $self->{_validated_parameters} = Yetie::Parameters->new(%output);
    return $self->{_validated_parameters};
}

sub render_error {
    my ( $self, $name ) = @_;
    my $field = $self->fieldset->field($name);
    $self->tag_helpers->error_block($field);
}

sub render_help {
    my ( $self, $name ) = @_;
    my $field = $self->fieldset->field($name);
    $self->tag_helpers->help_block($field);
}

sub render_label {
    my ( $self, $name, %attrs ) = @_;
    my $field = $self->fieldset->field($name);
    $self->tag_helpers->label_for( $field, %attrs );
}

sub render {
    my ( $self, $name, %attrs ) = @_;

    my $value = $self->controller->req->params->param($name);
    $attrs{value} = $value if defined $value;

    my $field = $self->fieldset->field($name);
    my $method = $field->type || 'text';
    $self->tag_helpers->$method( $field, %attrs );
}

sub scope_param { shift->params->every_param(shift) }

sub validate {
    my $self     = shift;
    my $v        = $self->controller->validation;
    my $names    = $self->controller->req->params->names;
    my $fieldset = $self->fieldset;

    foreach my $field_key ( @{ $fieldset->field_keys } ) {
        my $required = $fieldset->schema->{$field_key}->{required};
        my $filters  = $fieldset->filters($field_key);
        my $checks   = $fieldset->checks($field_key);

        # multiple field: eg. parameter_name = "favorite_color[]"
        $field_key .= '[]' if $fieldset->schema($field_key)->{multiple};

        # expanding field: e.g. field_key = "user.[].id" parameter_name = "user.0.id"
        if ( $field_key =~ m/\.\[\]/ ) {
            my @match = grep { my $name = $fieldset->_replace_key($_); $field_key eq $name } @{$names};
            foreach my $key (@match) {
                $required ? $v->required( $key, @{$filters} ) : $v->optional( $key, @{$filters} );
                $self->_do_check($_) for @$checks;
                _replace_req_param( $self->controller, $key );
            }
        }
        else {
            $required ? $v->required( $field_key, @{$filters} ) : $v->optional( $field_key, @{$filters} );
            $self->_do_check($_) for @$checks;
            _replace_req_param( $self->controller, $field_key );
        }
    }
    $self->is_validated(1);
    return $v->has_error ? undef : 1;
}

sub validation { shift->controller->validation }

# NOTE: filter適用後の値をfill-in formで使われるようにする
sub _replace_req_param {
    my ( $c, $key ) = @_;
    my $validated_value = $c->validation->param($key);
    $c->param( $key => $validated_value ) if $validated_value;
}

sub _do_check {
    my $self = shift;

    my $v = $self->controller->validation;
    my ( $check, @args ) = ref $_[0] eq 'ARRAY' ? @{ $_[0] } : $_[0];
    return $v->$check unless @args;

    # scalar refference to preference value
    @args = map { ref $_ eq 'SCALAR' ? $self->controller->pref( ${$_} ) : $_ } @args;
    return $v->$check(@args);
}

sub _fieldset {
    my $self = shift;
    my $ns = shift || die 'Argument empty';
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;

    my $class = $self->name_space . "::" . $ns;
    load_class($class);
    return $class->new;
}

sub _fill_field {
    my ( $field, $value ) = @_;

    if ( $field->type =~ /^(choice|select|checkbox|radio)$/ ) {
        $field->choices( _fill_choice_field( $field->choices, $value ) );
    }
    else { $field->default_value($value) }
}

sub _fill_choice_field {
    my ( $choices, $value ) = @_;

    foreach my $v ( @{$choices} ) {
        if ( blessed $v && $v->isa('Mojo::Collection') ) {
            my ( $label, $values, @attrs ) = @{$v};

            $values = _fill_choice_field( $values, $value );
            $v = c( $label, $values, @attrs );
        }
        elsif ( ref $v eq 'ARRAY' ) {
            push @{$v}, ( choiced => 1 ) if $v->[1] eq $value;
        }
        else {
            $v = [ $v => $v, choiced => 1 ] if $v eq $value;
        }
    }
    return $choices;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Form::Base - Form for Yetie

=head1 SYNOPSIS

    my $form = Yetie::Form::Base->new( 'foo', controller => $c );

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Form::Base> inherits all attributes from L<Mojo::Base> and implements the following new ones.

=head2 C<controller>

    my $controller = $form->controller;
    $form->controller( Mojolicious::Controller->new );

Return L<Mojolicious::Controller> object.

=head2 C<fieldset>

    my $fieldset = $form->fieldset;

Return L<Yetie::Form::FieldSet> object or C<undefined>.

=head2 C<is_validated>

    my $bool = $fieldset->is_validated;

Return boolean value.

=head2 C<name_space>

    my $ns = $form->name_space;
    $form->name_space('Your::FormSet');

Name space base.
Default Yetie::Form::FieldSet

=head2 C<validation>

    $validation = $fieldset->validation;

$controller->validation alias.

=head1 METHODS

L<Yetie::Form::Base> inherits all methods from L<Mojo::Base> and implements the following new ones.

=head2 C<field>

    my $field = $form->field('field_name');

    # Longer version
    my $field = $form->fieldset->field('field_name');

Return L<Yetie::Form::Field> object.

=head2 C<fill_in>

    $form->fill_in($entity);

    my $form = Yetie::Form::Base->new('foo')->fill_in($entity);

Fill in form default value from L<Yetie::Domain::Entity> object.
Return L<Yetie::Form::Base> object.

=head2 C<has_data>

    $bool = $form->has_data;

L<Mojolicious::Validator::Validation/has_data>

=head2 C<param>

    # Return scalar
    my $param = $form->param('name');

    # Return array refference
    my $param = $form->param('favorite[]')

The parameter is a validated values.
This method should be called after the L</validate> method.

=head2 C<params>

    my $validated_params = $form->params;

Return L<Mojo::Parameters> object.
All parameters are validated values.
This method should be called after the L</validate> method.

=head2 C<render_error>

    $form->render_error('email');

If `$c->validation` has an error message it rendering HTML error message block.

=head2 C<render_help>

    $form->render_help('email');

Rendering HTML help block.

=head2 C<render_label>

    $form->render_label('email');
    $form->render_label( 'email', class => 'foo' );

Rendering HTML label tag.

=head2 C<render>

    $form->render('email');
    $form->render('email', value => 'foo', placeholder => 'bar' );

Rendering HTML form widget(field or fields).

=head2 C<scope_param>

    my $scope = $form->scope_param('user');

Return hash refference or array refference.
The parameter is a validated values.
This method should be called after the L</validate> method.

Get expanded parameter. SEE L<CGI::Expand/expand_hash>

=head2 C<validation>

    my $validation = $form->validation;

Return L<Mojo::Validator::Validation> object.

Alias $controller->validation

=head2 C<validate>

    my $bool = $form->validate;
    say 'Validation failure!' unless $bool;

Return boolean. success return true.

=head1 SEE ALSO

L<Yetie::Form>, L<Yetie::Form::FieldSet>, L<Yetie::Form::Field>, L<Yetie::Form::TagHelpers>

=cut
