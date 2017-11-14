package Yetie::Form::Base;
use Mojo::Base -base;
use Carp qw(croak);
use CGI::Expand qw/expand_hash/;
use Mojolicious::Controller;
use Yetie::Util qw(load_class);

# use Yetie::Form::FieldSet;

has controller => sub { Mojolicious::Controller->new };

# has fieldset   => sub { Yetie::Form::FieldSet->new };
has 'fieldset';
has is_validated => '0';
has name_space   => 'Yetie::Form::FieldSet';

sub new {
    my ( $class, $ns ) = ( shift, shift );

    my $self = $class->SUPER::new(@_);
    $self->fieldset( $self->_fieldset($ns) );
    return $self;
}

sub has_data { shift->validation->has_data }

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

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Form::Base - Form for Yetie

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Form::Base> inherits all attributes from L<Mojo::Base> and implements the following new ones.

=head2 C<controller>

Return L<Mojolicious::Controller> object.

=head2 C<fieldset>

Return L<Yetie::Form::FieldSet> object.

=head2 C<is_validated>

Return boolean value.

=head2 C<name_space>

Name space base.

=head1 METHODS

L<Yetie::Form::Base> inherits all methods from L<Mojo::Base> and implements the following new ones.

=head2 C<has_data>

    $bool = $fieldset->has_data;

L<Mojolicious::Validator::Validation/has_data>

=head2 C<validation>

Return L<Mojo::Validator::Validation> object.

Alias $controller->validation

=head1 SEE ALSO

L<Yetie::Form>, L<Yetie::Form::FieldSet>, L<Yetie::Form::Field>, L<Mojolicious::Plugin>

=cut
