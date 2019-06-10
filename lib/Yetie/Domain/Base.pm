package Yetie::Domain::Base;
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

has _hash_sum => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
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

    # Lazy build
    $self->_hash_sum;
}

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

    # FIXME: need recursive rehash
    $self->_set_hash_sum( $self->hash_code );
    return $self;
}

sub set_attributes {
    my ( $self, $params ) = @_;

    foreach my $key ( keys %{$params} ) {
        my $value = $params->{$key};
        $self->$key($value);
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

=head1 METHODS

L<Yetie::Domain::Base> inherits all methods from L<Moose> and implements
the following new ones.

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

=head2 C<set_attributes>

    $obj->set_attributes( \%parameters );

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose>, L<MooseX::StrictConstructor>
