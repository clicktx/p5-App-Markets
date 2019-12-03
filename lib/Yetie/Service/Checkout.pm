package Yetie::Service::Checkout;
use Mojo::Base 'Yetie::Service';

sub add_all_cart_items {
    my $self = shift;

    my $cart     = $self->controller->cart;
    my $items    = $cart->items->to_array;
    my $checkout = $self->get;
    $checkout->sales_orders->first->items->append( @{$items} );

    return;
}

sub calculate_shipping_fees {
    my $self = shift;

    my $checkout = $self->get;
    $checkout->sales_orders->each(
        sub {
            my $sales_order = shift;

            my $shipping_fee = $self->service('shipping')->get_shipping_fee($sales_order);
            my $price = $sales_order->shipping_fee->clone( value => $shipping_fee );
            $sales_order->shipping_fee($price);
        }
    );
    return;
}

sub delete {
    my $self = shift;

    $self->server_session->clear('checkout');
    delete $self->controller->stash->{checkout};
    return $self;
}

sub get {
    my $self = shift;

    my $checkout = $self->controller->stash('checkout');
    return $self->_load if !$checkout;

    return $checkout;
}

sub save {
    my $self = shift;

    my $checkout = $self->controller->stash('checkout');
    return if !$checkout;

    return $self->_update($checkout);
}

sub set_billing_address {
    my ( $self, @args ) = @_;

    my $checkout = $self->get;
    $checkout->set_billing_address(@args);
    return $self->save;
}

sub set_shipping_address {
    my ( $self, @args ) = @_;

    my $checkout = $self->get;
    $checkout->set_shipping_address(@args);
    return $self->save;
}

sub _create {
    my $self = shift;

    my $checkout = $self->factory('entity-checkout')->construct();
    my $price    = $self->service('price')->create_object(0);
    my $tax_rule = $self->service('tax')->get_rule;
    $checkout->sales_orders->create_sales_order(
        shipping_fee => $price->to_data,
        tax_rule     => $tax_rule->to_data,
    );
    $self->_update($checkout);

    $self->controller->stash( checkout => $checkout );
    return $checkout;
}

sub _load {
    my $self = shift;

    my $data = $self->server_session->data('checkout');
    return $self->_create if !$data;

    my $checkout = $self->factory('entity-checkout')->construct($data);
    $self->controller->stash( checkout => $checkout );
    return $checkout;
}

sub _update {
    my ( $self, $entity ) = @_;

    $self->server_session->data( checkout => $entity->to_data );
    return $self;
}

1;
__END__

=head1 NAME

Yetie::Service::Checkout

=head1 SYNOPSIS

    my $c = shift;

    # Load
    my $checkout = $c->service('checkout')->get;

    ....

    # Store
    $c->service('checkout')->save;

    # Remove
    $c->service('checkout')->delete;

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Checkout> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Checkout> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<add_all_cart_items>

Add all cart items to the first sales order.

    $service->add_all_cart_items;

=head2 C<calculate_shipping_fees>

    $service->calculate_shipping_fees;

Calculate shipping fees.

=head2 C<delete>

    $service->delete;

=head2 C<get>

    my $checkout = $service->get;

Return L<Yetie::Domain::Entity::Checkout> object.

=head2 C<save>

    $service->save;

=head2 C<set_billing_address>

    # Set or update
    $service->set_billings_address( $address_obj );

See L<Yetie::Domain::Entity::Checkout/set_billings_address>

=head2 C<set_shipping_address>

    # Set or update first element
    $service->set_shipping_address( $address_obj );

    # Set or update multiple elements
    $service->set_shipping_address( 1 => $address_obj, 3 => $address_obj, ... );
    $service->set_shipping_address( [ $address_obj, $address_obj, ... ] );

See L<Yetie::Domain::Entity::Checkout/set_shipping_address>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Checkout>, L<Yetie::Service>
