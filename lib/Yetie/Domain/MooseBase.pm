package Yetie::Domain::MooseBase;
use Moose;
use MooseX::StrictConstructor;
use Data::Dumper;
use Mojo::Util qw{};

has _hash_sum => ( is => 'ro', lazy_build => 1 );

sub _build__hash_sum { return shift->hash_code }

sub BUILD {
    my $self = shift;

    # Lazy build
    $self->_hash_sum;
}

sub equals {
    my ( $self, $obj ) = @_;
    return $self->hash_code eq $obj->hash_code ? 1 : 0;
}

sub get_all_attribute_names {
    return sort map { $_->name } shift->meta->get_all_attributes;
}

sub get_public_attribute_names {
    return grep { /\A(?!_).*/sxm } shift->get_all_attribute_names;
}

sub hash_code { return Mojo::Util::sha1_sum( shift->_dump_public_attr ) }

sub is_modified {
    my $self = shift;
    return $self->_hash_sum ne $self->hash_code ? 1 : 0;
}

sub _dump_public_attr {
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Sortkeys = sub {
        my ($hash) = @_;
        my @keys = grep { /\A(?!_).*/sxm } ( sort keys %{$hash} );
        return \@keys;
    };
    return Dumper(shift);
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

=head2 C<equals>

    my $bool = $obj->equals($object);

Return boolean value.

=head2 C<get_all_attribute_names>

    my @names = $obj->get_all_attribute_names;

Return all attribute name list.

=head2 C<get_public_attribute_names>

    my @names = $obj->get_public_attribute_names;

Return all public attribute name list.

=head2 C<hash_code>

    # "960167e90089e5ebe6a583e86b4c77507afb70b7"
    my $sha1_sum = $obj->hash_code;

Return sha1 string.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose>, L<MooseX::StrictConstructor>
