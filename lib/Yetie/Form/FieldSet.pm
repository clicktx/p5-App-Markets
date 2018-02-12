package Yetie::Form::FieldSet;
use Mojo::Base -base;
use Mojo::Util qw/monkey_patch/;
use Mojo::Collection;
use Tie::IxHash;
use Yetie::Form::Field;
use Mojo::Util;
use Yetie::Util;

sub append_field {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    ${"${class}::schema"}{$field_key} = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
}

sub checks { shift->_get_data( shift, 'validations' ) }

sub export_field {
    my $self = shift;
    my $class = ref $self || $self;

    my $caller = $_[0] ? $_[0] =~ /::/ ? shift : caller : caller;
    my @field_keys = @_ ? @_ : @{ $self->field_keys };

    no strict 'refs';
    ${"${caller}::schema"}{$_} = $class->schema($_) for @field_keys;
}

sub field_info {
    my $self = shift;
    my $class = ref $self || $self;

    return %{ $class->schema(shift) };
}

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

    my $field_key = $self->_replace_key($name);
    my $cache_key = $name eq $field_key ? $field_key : "$field_key=$name";
    return $self->{_field}->{$cache_key} if $self->{_field}->{$cache_key};

    no strict 'refs';
    my $attrs = $field_key ? ${"${class}::schema"}{$field_key} : {};
    my $field = Yetie::Form::Field->new( field_key => $field_key, name => $name, %{$attrs}, %{$args} );
    $self->{_field}->{$cache_key} = $field;
    return $field;
}

sub filters { shift->_get_data( shift, 'filters' ) }

sub import {
    my $class  = shift;
    my $caller = caller;

    no strict 'refs';
    no warnings 'once';
    push @{"${caller}::ISA"}, $class;
    tie %{"${caller}::schema"}, 'Tie::IxHash';
    monkey_patch $caller, 'extends',   sub { _extends(@_) };
    monkey_patch $caller, 'fieldset',  sub { _fieldset(@_) };
    monkey_patch $caller, 'has_field', sub { append_field( $caller, @_ ) };
    monkey_patch $caller, 'c',         sub { Mojo::Collection->new(@_) };

    return unless @_;

    # Export field
    $_[0] eq '-all' ? $class->export_field($caller) : $class->export_field( $caller, @_ );
}

sub remove {
    my ( $self, $field_key ) = ( shift, shift );
    return unless ( my $class = ref $self || $self ) && $field_key;

    no strict 'refs';
    delete ${"${class}::schema"}{$field_key};
}

sub schema {
    my ( $self, $field_key ) = @_;
    my $class = ref $self || $self;

    no strict 'refs';
    my %schema = %{"${class}::schema"};
    return $field_key ? $schema{$field_key} : \%schema;
}

sub _extends {
    my ( $class, $field ) = split( /#/, shift );
    _fieldset($class)->field_info($field);
}

sub _fieldset {
    my $target = shift;

    my $fieldset = __PACKAGE__ . '::' . Mojo::Util::camelize($target);
    Yetie::Util::load_class($fieldset);
    return $fieldset;
}

sub _get_data {
    my ( $self, $field_key, $attr_name ) = @_;

    if ($field_key) {
        return ${ $self->schema }{$field_key} ? ${ $self->schema }{$field_key}->{$attr_name} || [] : undef;
    }
    else {
        my %data = map { $_ => $self->schema->{$_}->{$attr_name} || [] } @{ $self->field_keys };
        return \%data || {};
    }
}

sub _replace_key {
    my ( $self, $arg ) = @_;
    $arg =~ s/\.\d/.[]/g;
    return $arg;
}

1;
__END__

=encoding utf8

=head1 NAME

Yetie::Form::FieldSet

=head1 SYNOPSIS

    # Your form field set class
    package Yetie::Form::FieldSet::User;
    use Yetie::Form::FieldSet;

    has_field 'name' => ( %args );
    ...

    # In controller
    my $form = $c->form('user');

    if ( $form->do_validate ){

        # Get validated parameters
        my $params = $form->params;

        $c->render( text => 'thanks');
    } else {
        $c->render( text => 'validation failure');
    }

=head1 IMPORT OPTIONS

    # Your form field set base class
    package Yetie::Form::FieldSet::Base;
    use Yetie::Form::FieldSet;

    has_field 'email' => ( ... );
    has_field 'password' => ( ... );
    ...
    1;

    # Import from base class
    package Yetie::Form::FieldSet::Hoge;
    use Yetie::Form::FieldSet::Base qw(email password);
    ...
    1;

Import fields 'email' and 'password'.

=head2 C<-all>

    package Yetie::Form::FieldSet::Hoge;
    use Yetie::Form::FieldSet::Base -all;
    ...
    1;

Import all fields.

=head1 SCHEMA

    package Yetie::Form::FieldSet::Example;
    use Mojo::Base -strict;
    use Yetie::Form::FieldSet;

    has_field email => (
        type          => 'email',
        placeholder   => 'name@domain',
        label         => 'E-mail',
        default_value => 'a@b.com',
        required      => 1,
        filters       => [qw(trim)],
        validations   => [],
    );

    has_field password => (
        type        => 'password',
        placeholder => 'your password',
        label       => 'Password',
        required      => 1,
        filters     => [],
        validations => [ { size => [ \'customer_password_min', \'customer_password_max' ] }, ],
        help        => sub {
            my $c = shift;
            $c->__x(
                'Must be {min}-{max} characters long.',
                { min => $c->pref('customer_password_min'), max => $c->pref('customer_password_max') },
            );
        },
    );

    has_field password_again => (
        type        => 'password',
        placeholder => 'password again',
        label       => 'Password Again',
        required    => 1,
        filters        => [],
        validations    => [ { equal_to => 'password' } ],
        help           => 'Type Password Again.',
        error_messages => {
            equal_to => 'The passwords you entered do not much.',
        },
    );

=head2 C<validations>

    validations => [ int, { size => [ 4, 8 ] }, ... ],

Set array refference.
If the method has arguments, it returns hash refference.

    # Value from Preferences
    validations => [ int, { size => [ \'password_min', \'password_max' ] }, ... ],

Passing a scalar reffernce as an arguments to the validator method expands from preferences.

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 FUNCTIONS

L<Yetie::Form::FieldSet> inherits all functions from L<Mojo::Base> and implements
the following new ones.

=head2 C<c>

    my $collection = c(1, 2, 3);

Construct a new array-based L<Mojo::Collection> object.

=head2 C<extends>

    my %field_info = extends('foo#bar');

    # longer version
    my %field_info = fieldset('foo')->field_info('bar');

=head2 C<fieldset>

    # "Yetie::Form::FieldSet::Foo"
    my $pkg = fieldset('foo');

    has_field 'customer_name' => fieldset('person')->field_info('name');

Return package name.
Load a class.

=head2 C<has_field>

    has_field 'field_name' => ( type => 'text', ... );

    has_field 'field_name' => { type => 'text', ...  };

=head1 METHODS

L<Yetie::Form::FieldSet> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<append_field>

    $fieldset->append_field( 'field_name' => ( %args ) );

    $fieldset->append_field( 'field_name' => \%args );

=head2 C<checks>

    # Return array refference
    # [ 'validation1', 'validation2', ... ]
    my $checks = $fieldset->checks('email');

    # Return hash refference
    # { field_key => [ 'validation1', 'validation2', ... ], field_key2 => [ 'validation1', 'validation2', ... ] }
    my $checks = $fieldset->checks;

=head2 C<export_field>

    use Yetie::Form::FieldSet::Basic;

    # 'email', 'password' exported.
    Yetie::Form::FieldSet::Basic->export_field(qw/email password/);

    # All field exported.
    Yetie::Form::FieldSet::Basic->export_field();

=head2 C<field_info>

    my %field_info = $fieldset->field_info($field_name);

This method is an alias for L<schema>.

Returns the field metadata hash for a field, as originally passed to "has_field".
See L</has_field> above for information on the contents of the hash.

=head2 C<field_keys>

    my @field_keys = $fieldset->field_keys;

    # Return array refference
    my $field_keys = $fieldset->field_keys;

=head2 C<field>

    my $field = $fieldset->field('field_name');

Return L<Yetie::Form::Field> object.
Object once created are cached in "$fieldset->{_field}->{$field_key}".

=head2 C<filters>

    # Return array refference
    # [ 'filter1', 'filter2', ... ]
    my $filters = $fieldset->filters('field_key');

    # Return hash refference
    # { field_key => [ 'filter1', 'filter2', ... ], field_key2 => [ 'filter1', 'filter2', ... ] }
    my $filters = $fieldset->filters;

=head2 C<remove>

    $fieldset->remove('field_name');

=head2 C<schema>

    my $schema = $fieldset->schema;

    my $field_schema = $fieldset->schema('field_key');

Return hash refference. Get a field definition.

=head1 SEE ALSO

L<Yetie::Form>, L<Yetie::Form::Base>, L<Yetie::Form::Field>, L<Yetie::Form::TagHelpers>

=cut
