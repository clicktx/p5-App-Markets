package Markets::Form::FieldSet;
use Mojo::Base -base;
use Mojo::Util qw/monkey_patch/;
use Tie::IxHash;
use Scalar::Util qw/weaken/;
use Mojolicious::Controller;
use Mojo::Collection;
use Markets::Form::Field;

has controller => sub { Mojolicious::Controller->new };

sub append {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    ${"${class}::schema"}{$field_key} = +{@_};
}

sub checks { shift->_get_data_from_field( shift, 'validations' ) }

sub field_keys {
    my $self = shift;
    my $class = ref $self || $self;

    no strict 'refs';
    my @field_keys = keys %{"${class}::schema"};
    return wantarray ? @field_keys : \@field_keys;
}

sub field {
    my ( $self, $name ) = ( shift, shift );
    my $args = @_ > 1 ? +{@_} : shift || {};
    my $class = ref $self || $self;

    my $field_key = _replace_key($name);
    return $self->{_field}->{$field_key} if $self->{_field}->{$field_key};

    no strict 'refs';
    my $attrs = $field_key ? ${"${class}::schema"}{$field_key} : {};
    my $field = Markets::Form::Field->new( field_key => $field_key, name => $name, %{$args}, %{$attrs} );
    $self->{_field}->{$field_key} = $field;

    return $field;
}

sub filters { shift->_get_data_from_field( shift, 'filters' ) }

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    weaken $self->{controller};
    return $self;
}

sub import {
    my $class  = shift;
    my $caller = caller;

    no strict 'refs';
    no warnings 'once';
    push @{"${caller}::ISA"}, $class;
    tie %{"${caller}::schema"}, 'Tie::IxHash';
    monkey_patch $caller, 'has_field', sub { append( $caller, @_ ) };
    monkey_patch $caller, 'c', sub { Mojo::Collection->new(@_) };
}

sub remove {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    delete ${"${class}::schema"}{$field_key};
}

sub render_label {
    my $self = shift;
    my $name = shift;

    $self->field($name)->label_for;
}

sub render {
    my $self = shift;
    my $name = shift;

    my %attrs;
    my $value = $self->controller->req->params->param($name);
    $attrs{value} = $value if defined $value;

    my $field = $self->field( $name, %attrs );
    my $method = $field->type || 'text';
    $field->$method;
}

sub schema {
    my ( $self, $field_key ) = @_;
    my $class = ref $self || $self;

    no strict 'refs';
    my %schema = %{"${class}::schema"};
    return $field_key ? $schema{$field_key} : \%schema;
}

sub validate {
    my $self  = shift;
    my $v     = $self->controller->validation;
    my $names = $self->controller->req->params->names;

    foreach my $field_key ( @{ $self->field_keys } ) {
        my $required = $self->schema->{$field_key}->{required};
        my $filters  = $self->filters($field_key);
        my $cheks    = $self->checks($field_key);

        if ( $field_key =~ m/\.\[\]/ ) {
            my @match = grep { my $name = _replace_key($_); $field_key eq $name } @{$names};
            foreach my $key (@match) {
                $required ? $v->required( $key, @{$filters} ) : $v->optional( $key, @{$filters} );
                _do_check( $v, $_ ) for @$cheks;
            }
        }
        else {
            $required ? $v->required( $field_key, @{$filters} ) : $v->optional( $field_key, @{$filters} );
            _do_check( $v, $_ ) for @$cheks;
        }
    }
    return $v->has_error ? undef : 1;
}

sub _get_data_from_field {
    my ( $self, $key, $type ) = @_;

    if ($key) {
        my %schema = %{ $self->schema };
        return $schema{$key} ? $schema{$key}->{$type} || [] : undef;
    }
    else {
        my %data = map { $_ => $self->schema->{$_}->{$type} || [] } @{ $self->field_keys };
        return \%data || {};
    }
}

sub _do_check {
    my $v = shift;

    my ( $check, $args ) = ref $_[0] ? %{ $_[0] } : ( $_[0], undef );
    return $v->$check unless $args;

    return ref $args eq 'ARRAY' ? $v->$check( @{$args} ) : $v->$check($args);
}

sub _replace_key {
    my $arg = shift;
    $arg =~ s/\.\d/.[]/g;
    $arg;
}

1;
__END__

=encoding utf8

=head1 NAME

Markets::Form::Field

=head1 SYNOPSIS

    # Your form field class
    package Markets::Form::Type::User;
    use Markets::Form::FieldSet;

    has_field 'name' => ( %args );
    ...

    # In controller
    my $fieldset = $c->form_set('user');

    if ( $fieldset->validate ){
        $c->render( text => 'thanks');
    } else {
        $c->render( text => 'validation failure');
    }


=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<controller>

    my $controller = $fieldset->controller;
    $fieldset->controller( Mojolicious::Controller->new );

Return L<Mojolicious::Controller> object.

=head1 FUNCTIONS

=head2 C<c>

    my $collection = c(1, 2, 3);

Construct a new array-based L<Mojo::Collection> object.

=head2 C<has_field>

    has_field 'field_name' => ( type => 'text', ... );

=head1 METHODS

=head2 C<append>

    $fieldset->append( 'field_name' => ( %args ) );

=head2 C<checks>

    # Return array refference
    my $checks = $fieldset->checks('email');

    # Return hash refference
    my $checks = $fieldset->checks;

=head2 C<field_keys>

    my @field_keys = $fieldset->field_keys;

    # Return array refference
    my $field_keys = $fieldset->field_keys;

=head2 C<field>

    my $field = $fieldset->field('field_name');

Return L<Markets::Form::Field> object.
Object once created are cached in "$fieldset->{_field}->{$field_key}".

=head2 C<filters>

    # Return array refference
    my $filters = $fieldset->filters('field_key');

    # Return hash refference
    my $filters = $fieldset->filters;

=head2 C<remove>

    $fieldset->remove('field_name');

=head2 C<render_label>

    $fieldset->render_label('email');

Return code refference.

=head2 C<render>

    $fieldset->render('email');

Return code refference.

=head2 C<schema>

    my $schema = $fieldset->schema;

    my $field_schema = $fieldset->schema('field_key');

Return hash refference. Get a field definition.

=head2 C<validate>

    my $bool = $fieldset->validate;
    say 'Validation failure!' unless $bool;

Return boolean. success return true.

=head1 SEE ALSO

=cut
