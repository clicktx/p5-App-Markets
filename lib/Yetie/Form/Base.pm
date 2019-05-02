package Yetie::Form::Base;
use Mojo::Base -base;
use Carp qw(croak);
use CGI::Expand qw(expand_hash collapse_hash);
use Scalar::Util qw(blessed);
use Mojo::Collection qw(c);
use Mojolicious::Controller;
use Yetie::Util qw(load_class);
use Yetie::App::Core::Parameters;
use Yetie::App::Core::Form::TagHelpers;

has controller => sub { Mojolicious::Controller->new };
has is_validated => '0';
has name_space   => 'Yetie::Form::FieldSet';
has tag_helpers  => sub { Yetie::App::Core::Form::TagHelpers->new( shift->controller ) };
has [qw(fieldset validated_parameters)];

sub append_error_classes {
    my $self = shift;
    return if !@_;

    foreach my $name (@_) { $self->field($name)->append_error_class }
    return;
}

sub do_validate {
    my $self     = shift;
    my $c        = $self->controller;
    my $fieldset = $self->fieldset;

    foreach my $field_key ( @{ $fieldset->field_keys } ) {
        my $required = $fieldset->schema->{$field_key}->{required};
        my $filters  = $fieldset->filters($field_key);
        my $checks   = $fieldset->checks($field_key);

        # NOTE: expanding field
        # e.g. field_key = "user.[].id" expanding to parameter_name = "user.0.id"
        my $names = $c->req->params->names;
        my @keys =
          $field_key =~ m/\.\[]|\.\{}/
          ? grep { $fieldset->replace_key($_) eq $field_key } @{$names}
          : ($field_key);
        $self->_validate_field( $_ => $required, $filters, $checks ) for @keys;
    }
    $self->is_validated(1);
    return $c->validation->has_error ? undef : 1;
}

sub every_param { shift->params->every_param(shift) }

sub field { shift->fieldset->field(@_) }

sub fill_in {
    my ( $self, $entity ) = @_;

    my $flat_hash = collapse_hash( $entity->to_data );
    foreach my $key ( keys %{$flat_hash} ) {
        $key =~ /(.+)\.(\d+)$|(.+)/;
        my $field_name = $1 || $3;
        my $value      = $flat_hash->{$key};
        my $field      = $self->fieldset->field($field_name);
        _fill_field( $field, $value ) if $field->type;
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

sub param { shift->every_param(shift)->[-1] }

sub params {
    my $self = shift;
    croak 'do not call "do_validate" method' unless $self->is_validated;
    return $self->validated_parameters if $self->validated_parameters;

    # NOTE: 'Mojolicious::Validator::Validation->output' does not hold parameters with empty strings ;(
    my $v          = $self->validation;
    my %field_keys = map { $_ => 1 } @{ $self->fieldset->field_keys };
    my @input_keys = grep { $field_keys{ $self->fieldset->replace_key($_) } } keys %{ $v->input };
    my %output;
    $output{$_} = $v->output->{$_} // '' for @input_keys;

    # Expand hash
    my $expand_hash = expand_hash( \%output );
    my %parameters = ( %output, %{$expand_hash} );

    # Cache
    $self->validated_parameters( Yetie::App::Core::Parameters->new(%parameters) );
    return $self->validated_parameters;
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
    my ( $self, $name ) = ( shift, shift );
    my %attrs = @_;

    my $field = $self->fieldset->field($name);
    $self->tag_helpers->label_for( $field, %attrs );
}

sub render {
    my ( $self, $name ) = ( shift, shift );
    my %attrs = @_;

    my $field = $self->fieldset->field($name);
    my $method = $attrs{type} || $field->type || 'text';
    $self->tag_helpers->$method( $field, %attrs );
}

sub scope_param { shift->params->every_param(shift) }

sub validation { shift->controller->validation }

sub _do_check {
    my $self = shift;
    my $c    = $self->controller;
    my $v    = $c->validation;

    my ( $check, @args ) = ref $_[0] eq 'ARRAY' ? @{ $_[0] } : $_[0];
    return $v->$check unless @args;

    # scalar reference to preference value
    @args = map { ref $_ eq 'SCALAR' ? $c->pref( ${$_} ) : $_ } @args;
    return $v->$check(@args);
}

sub _fieldset {
    my $self = shift;
    my $ns = shift || '';
    $ns = Mojo::Util::camelize($ns) if $ns =~ /^[a-z]/;

    my $class = $ns ? $self->name_space . "::" . $ns : $self->name_space;
    load_class($class);
    return $class->new;
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

sub _fill_field {
    my ( $field, $value ) = @_;

    if ( $field->type =~ /^(choice|select|checkbox|radio)$/ ) {
        $field->choices( _fill_choice_field( $field->choices, $value ) );
    }
    else { $field->default_value($value) }
}

# NOTE: filter適用後の値をfill-in formで使われるようにする
sub _replace_req_param {
    my ( $self, $key ) = @_;
    my $c         = $self->controller;
    my $validated = $c->validation->every_param($key);

    # parameterが無い場合は空文字を設定する
    my $value = @{$validated} ? $validated : '';
    $c->param( $key => $value );
}

sub _validate_field {
    my ( $self, $field_key, $required, $filters, $checks ) = @_;
    my $v = $self->controller->validation;
    $required ? $v->required( $field_key, @{$filters} ) : $v->optional( $field_key, @{$filters} );
    $self->_do_check($_) for @$checks;

    # NOTE: filter適用後の値をfill-in formで使われるようにする
    $self->_replace_req_param($field_key);
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

=head2 C<validated_parameters>

    my $params = $fieldset->validated_parameters;

Return L<Yetie::App::Core::Parameters> object or C<undefined>.

=head1 METHODS

L<Yetie::Form::Base> inherits all methods from L<Mojo::Base> and implements the following new ones.

=head2 C<append_error_classes>

    $form->append_error_classes( 'foo', 'bar', 'baz' );

    # Longer version
    $form->field($_)->append_error_class for qw(foo bar baz);

Add class "field-with-error" to all fields.

See L<Yetie::Form::Field/append_error_class>

=head2 C<do_validate>

    my $bool = $form->do_validate;
    say 'Validation failure!' unless $bool;

Return boolean. success return true.

=head2 C<every_param>

    my $params = $form->every_param;

Return Array reference.

    # Get first value
    say $form->every_param('foo')->[0];

The parameter is a validated values.
This method should be called after the L</do_validate> method.

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

    # Return last parameter in parameters
    my $param = $form->param('favorite[]')

The parameter is a validated values.
This method should be called after the L</append_error_classes> method.

=head2 C<params>

    my $validated_params = $form->params;

Return L<Mojo::Parameters> object.
All parameters are validated values.
This method should be called after the L</do_validate> method.

=head2 C<render_error>

    say $form->render_error('email');

If `$c->validation` has an error message it rendering HTML error message block.

=head2 C<render_help>

    say $form->render_help('email');

Rendering HTML help block.

=head2 C<render_label>

    say $form->render_label('email');
    say $form->render_label( 'email', class => 'foo' );

Rendering HTML label tag.

=head2 C<render>

    say $form->render('email');
    say $form->render('email', value => 'foo', placeholder => 'bar' );

Rendering HTML form widget(field or fields).

=head2 C<scope_param>

    my $scope = $form->scope_param('user');

Return array reference.
The parameter is a validated values.

NOTE: This method should be called after the L</do_validate> method.
Only the top level scope can be acquired.

Get expanded parameter. SEE L<CGI::Expand/expand_hash>

    # ?a.0=3&a.2=4&b.c=x&b.d=y

    $args_a = $form->scope_param('a');
    # [ 3, undef, 4 ]

    $args_b = $form->scope_param('b');
    # [ { c => 'x', d => 'y' } ]

=head2 C<validation>

    my $validation = $form->validation;

Return L<Mojo::Validator::Validation> object.

Alias $controller->validation

=head1 SEE ALSO

L<Yetie::App::Core::Form>, L<Yetie::Form::FieldSet>, L<Yetie::Form::Field>, L<Yetie::App::Core::Form::TagHelpers>

=cut
