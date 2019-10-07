package Yetie::Service::Checkout;
use Mojo::Base 'Yetie::Service';

sub add_all_cart_items {
    my $self = shift;

    my $cart     = $self->controller->cart;
    my $items    = $cart->items->to_array;
    my $checkout = $self->get;
    $checkout->shipments->first->items->append( @{$items} );
    return;
}

sub delete {
    my $self = shift;

    $self->server_session->clear('checkout');
    return;
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

    $self->_update($checkout);
    return;
}

sub _create {
    my $self = shift;

    $self->server_session->data( checkout => {} );
    my $checkout = $self->factory('entity-checkout')->construct();
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
    return;
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
    $checkout->save;

    # Remove
    $checkout->delete;

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Checkout> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Checkout> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<add_all_cart_items>

Add all cart items to the first shipment.

    $service->add_all_cart_items;

=head2 C<delete>

    $service->delete;

=head2 C<get>

    my $checkout = $service->get;

Return L<Yetie::Domain::Entity::Checkout> object.

=head2 C<save>

    $service->save;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
