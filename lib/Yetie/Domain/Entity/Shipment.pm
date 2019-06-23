package Yetie::Domain::Entity::Shipment;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has items => (
    is      => 'ro',
    isa     => 'Yetie::Domain::List::LineItems',
    default => sub { __PACKAGE__->factory('list-line_items')->construct() }
);
has shipping_address => (
    is      => 'rw',
    isa     => 'Yetie::Domain::Entity::Address',
    default => sub { __PACKAGE__->factory('entity-address')->construct() }
);

sub item_count { return shift->items->count }

sub subtotal {
    return shift->items->reduce( sub { $a + $b->subtotal }, 0 );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Shipment> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<shipping_address>

Return L<Yetie::Domain::Entity::Address> object.

=head2 C<items>

Return L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::Shipment> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<item_count>

    my $count = $shipment->item_count;

=head2 C<subtotal>

    my $subtotal = $shipment->subtotal;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
