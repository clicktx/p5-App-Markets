package Yetie::Domain::List::SalesOrders;
use Yetie::Util qw(args2hash);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List';

sub clear_items {
    return shift->each( sub { $_->items->clear } );
}

sub count_total_items {
    return shift->map( sub { $_->items->each } )->size;
}

sub create_sales_order {
    my $self = shift;
    my $args = args2hash(@_);

    my $sales_order = $self->factory('entity-sales_order')->construct($args);
    $self->append($sales_order);
    return $sales_order;
}

sub has_item { return shift->count_total_items ? 1 : 0 }

sub is_multiple { return shift->size > 1 ? 1 : 0 }

sub revert {
    my $self = shift;

    my $first_element = $self->first;
    return if !$first_element;

    $first_element->items->clear;
    my $sales_orders = $self->list->new($first_element);
    return $self->list($sales_orders);
}

sub subtotal_excl_tax {
    my $self = shift;

    my $price = $self->_init_price_object( is_tax_included => 0 );
    return $self->reduce( sub { $a + $b->subtotal_excl_tax }, $price );
}

sub subtotal_incl_tax {
    my $self = shift;

    my $price = $self->_init_price_object( is_tax_included => 1 );
    return $self->reduce( sub { $a + $b->subtotal_incl_tax }, $price );
}

# sub total_shipping_fee_excl_tax {
#     my $self = shift;

#     my $price = $self->_init_price_object( is_tax_included => 0 );
#     return $self->reduce( sub { $a + $b->shipping_fee_excl_tax }, $price );
# }

# sub total_shipping_fee_incl_tax {
#     my $self = shift;

#     my $price = $self->_init_price_object( is_tax_included => 1 );
#     return $self->reduce( sub { $a + $b->shipping_fee_incl_tax }, $price );
# }

sub total_quantity {
    return shift->reduce( sub { $a + $b->items->total_quantity }, 0 );
}

sub _init_price_object {
    my $self = shift;
    my $args = args2hash(@_);

    my $factory       = $self->factory('value-price');
    my $first_element = $self->first;
    return $factory->construct( is_tax_included => $args->{is_tax_included} ) if !$first_element;

    my $items = $first_element->items;
    return $factory->construct( is_tax_included => $args->{is_tax_included} ) if !$items->size;

    return $items->first->price->clone( value => 0, is_tax_included => $args->{is_tax_included} );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::SalesOrders

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::SalesOrders> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::SalesOrders> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<clear_items>

    my $sales_orders->clear_items;

=head2 C<count_total_items>

    my $count = $sales_orders->count_total_items;

=head2 C<create_sales_order>

    my $sales_order = $sales_orders->create_sales_order( %attributes );

    my $sales_order = $sales_orders->create_sales_order( \%attributes );

Create L<Yetie::Domain::Entity::SalesOder> object and add it to the collection.

Return L<Yetie::Domain::Entity::SalesOder> object.

=head2 C<has_item>

    my $bool = $sales_orders->has_item;

Return boolean value.

=head2 C<is_multiple>

    my $bool = $sales_orders->is_multiple;

Return boolean value.

=head2 C<revert>

    $sales_orders->revert;

Delete except the first element. Also delete all items of the first element.

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $items->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $items->subtotal_incl_tax;

=head2 C<total_quantity>

    my $qty = $sales_orders->total_quantity;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
