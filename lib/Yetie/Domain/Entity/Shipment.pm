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

sub count_items { return shift->items->size }

sub subtotal_excl_tax {
    my $self = shift;

    my $price = $self->_init_price;
    my $items_total = $self->items->reduce( sub { $a + $b->row_total_excl_tax }, $price );

    my $subtotal = $items_total;
    return $subtotal;
}

sub subtotal_incl_tax {
    my $self = shift;

    my $price = $self->_init_price;
    my $items_total = $self->items->reduce( sub { $a + $b->row_total_incl_tax }, $price );

    my $subtotal = $items_total;
    return $subtotal;
}

sub _init_price {
    my $self = shift;

    my $first_item = $self->items->first;
    return $first_item
      ? $first_item->price->clone( value => 0 )
      : Yetie::Factory->new('value-price')->construct;
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

Return L<Yetie::Domain::List::LineItems> object.

=head1 METHODS

L<Yetie::Domain::Entity::Shipment> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<count_items>

    my $count = $shipment->count_items;

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $shipment->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $shipment->subtotal_incl_tax;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
