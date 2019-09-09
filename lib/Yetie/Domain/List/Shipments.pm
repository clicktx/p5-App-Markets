package Yetie::Domain::List::Shipments;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List';

has _subtotal_excl_tax => (
    is       => 'ro',
    isa      => 'Yetie::Domain::Value::Price',
    lazy     => 1,
    builder  => '_build__subtotal_excl_tax',
    reader   => 'subtotal_excl_tax',
    init_arg => undef,
);

has _subtotal_incl_tax => (
    is       => 'ro',
    isa      => 'Yetie::Domain::Value::Price',
    lazy     => 1,
    builder  => '_build__subtotal_incl_tax',
    reader   => 'subtotal_incl_tax',
    init_arg => undef,
);

sub _init_price {
    my $self = shift;

    my $first_shipment = $self->first;
    return $first_shipment
      ? $first_shipment->items->first->price->clone( value => 0 )
      : Yetie::Factory->new('value-price')->construct;
}

sub _build__subtotal_excl_tax {
    my $self = shift;

    my $price = $self->_init_price;
    return $self->list->reduce( sub { $a + $b->items->subtotal_excl_tax }, $price );
}

sub _build__subtotal_incl_tax {
    my $self = shift;

    my $price = $self->_init_price;
    return $self->list->reduce( sub { $a + $b->items->subtotal_incl_tax }, $price );
}

sub clear_items {
    return shift->each( sub { $_->items->clear } );
}

sub create_shipment {
    my $self = shift;

    my $shipment = $self->factory('entity-shipment')->construct();
    $self->append($shipment);
    return $shipment;
}

sub has_item { return shift->count_total_items ? 1 : 0 }

sub has_shipment { return shift->size ? 1 : 0 }

sub is_multiple { return shift->size > 1 ? 1 : 0 }

sub count_total_items {
    return shift->list->map( sub { $_->items->each } )->size;
}

sub total_quantity {
    return shift->list->reduce( sub { $a + $b->items->total_quantity }, 0 );
}

sub revert {
    my $self = shift;

    my $shipment_first = $self->first;
    return if !$shipment_first;

    $shipment_first->items->clear;
    my $shipments = $self->list->new($shipment_first);
    return $self->list($shipments);
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::Shipments

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::Shipments> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $items->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $items->subtotal_incl_tax;

=head1 METHODS

L<Yetie::Domain::List::Shipments> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<clear_items>

    my $shipments->clear_items;

=head2 C<create_shipment>

    my $shipment = $shipments->create_shipment;

Create L<Yetie::Domain::Entity::Shipment> object and add it to the collection.

Return L<Yetie::Domain::Entity::Shipment> object.

=head2 C<has_item>

    my $bool = $shipments->has_item;

Return boolean value.

=head2 C<has_shipment>

    my $bool = $shipments->has_shipment;

Return boolean value.

=head2 C<is_multiple>

    my $bool = $shipments->is_multiple;

Return boolean value.

=head2 C<count_total_items>

    my $count = $shipments->count_total_items;

=head2 C<total_quantity>

    my $qty = $shipments->total_quantity;

=head2 C<revert>

    $shipments->revert;

Delete except the first element. Also delete all items of the first element.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
