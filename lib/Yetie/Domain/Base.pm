package Yetie::Domain::Base;
use Scalar::Util qw();
use Yetie::Factory;

use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

has _hash_sum => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
    reader     => 'hash_sum',
    writer     => '_set_hash_sum',
);
sub _build__hash_sum { return shift->hash_code }

# Do not created an undefined attributes
around BUILDARGS => sub {
    my ( $orig, $class ) = ( shift, shift );
    my %args = @_ ? @_ > 1 ? @_ : %{ $_[0] } : ();

    foreach my $key ( keys %args ) {
        my $ref = ref $args{$key};
        die 'Array and hash refference can not be used as arguments.' if $ref eq 'ARRAY' || $ref eq 'HASH';

        # Delete undefined
        if ( !defined $args{$key} ) { delete $args{$key} }
    }
    return $class->$orig(%args);
};

sub BUILD {
    my $self = shift;

    # touch
    $self->hash_sum;
}

sub args_to_hash { return %{ shift->args_to_hashref(@_) } }

sub args_to_hashref {
    my $self = shift;
    return @_ > 1 ? +{@_} : shift || {};
}

sub factory { return Yetie::Factory->new( $_[1] ) }

sub get_all_attribute_names {
    return ( sort map { $_->name } shift->meta->get_all_attributes );
}

sub get_public_attribute_names {
    return ( grep { /\A(?!_).*/sxm } shift->get_all_attribute_names );
}

sub hash_code {
    my ( $self, $arg ) = @_;
    return Mojo::Util::sha1_sum($arg) if $arg;

    return Mojo::Util::sha1_sum( $self->_dump_by_public_attributes );
}

sub rehash {
    my $self = shift;

    $self->_set_hash_sum( $self->hash_code );

    # recursive rehash
    my @attributes = $self->get_all_attribute_names;
    foreach my $attr (@attributes) {
        next if !$self->can($attr);                       # NOTE: for change attribute reader
        next if !Scalar::Util::blessed( $self->$attr );
        next if !$self->$attr->can('rehash');

        $self->$attr->rehash;
    }
    return $self;
}

sub set_attribute {
    my ( $self, $key, $value ) = @_;

    my $attr = $self->$key;
    Scalar::Util::blessed($attr) ? $attr->set_attributes($value) : $self->$key($value);
    return $self;
}

sub set_attributes {
    my $self = shift;
    my $args = $self->args_to_hashref(@_);

    foreach my $key ( keys %{$args} ) {
        my $value = $args->{$key};
        $self->set_attribute( $key, $value );
    }
    return $self;
}

sub _dump_by_public_attributes {
    my $self = shift;

    my $dump = '({';
    foreach my $attr ( $self->get_public_attribute_names ) {
        my $value = $self->$attr || q{};
        $dump .= "$attr=" . $value . q{,};
    }
    $dump .= '},' . ref($self) . ')';
    return $dump;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=encoding utf8

=head1 NAME

Yetie::Domain::Base

=head1 SYNOPSIS

    package Yetie::Domain::Foo;
    use Moose;
    extends 'Yetie::Domain::Base';

    has foo => ( is => 'ro' );

    no Moose;
    __PACKAGE__->meta->make_immutable;
    1;

=head1 DESCRIPTION

Domain object base class.

=head1 ATTRIBUTES

L<Yetie::Domain> inherits all attributes from L<Moose> and implements the following new ones.

=head2 C<hash_sum>

Return cached SHA1 checksum.

SEE L</hash_code>

=head1 METHODS

L<Yetie::Domain::Base> inherits all methods from L<Moose> and implements the following new ones.

=head2 C<args_to_hash>

    sub foo {
        my $self = shift;
        my %hash = $self->args_to_hash(@_);
        ...
    }

    # Arguments hash or hash reference
    $self->foo( bar => 1 );
    $self->foo( { baz => 2 } );

=head2 C<args_to_hashref>

    sub foo {
        my $self = shift;
        my $hash_ref = $self->args_to_hashref(@_);
        ...
    }

    # Arguments hash or hash reference
    $self->foo( bar => 1 );
    $self->foo( { baz => 2 } );

=head2 C<factory>

    __PACKAGE__->factory('entity-foo');

    my $factory = $obj->factory('value-bar');

Return L<Yetie::Factory> object.

=head2 C<get_all_attribute_names>

    my @names = $obj->get_all_attribute_names;

Return all attribute name list.

=head2 C<get_public_attribute_names>

    my @names = $obj->get_public_attribute_names;

Return all public attribute name list.

=head2 C<hash_code>

    my $sha1_sum = $obj->hash_code;
    my $sha1_sum = $obj->hash_code($bytes);

Return SHA1 checksum.

=head2 C<rehash>

    $obj->rehash;

Recreate object hash sum.

Recursive call for all attributes.

=head2 C<set_attribute>

    $obj->set_attribute( $key => $value );

=head2 C<set_attributes>

    $obj->set_attributes( %parameters );
    $obj->set_attributes( \%parameters );

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose>, L<MooseX::StrictConstructor>
