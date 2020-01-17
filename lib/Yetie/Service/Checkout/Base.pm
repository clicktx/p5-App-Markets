package Yetie::Service::Checkout::Base;
use Mojo::Base -role;

sub delete {
    my $self = shift;

    $self->server_session->clear('checkout');
    delete $self->controller->stash->{checkout};
    return $self;
}

sub destroy {
    my $self = shift;

    # Derele cart items
    $self->c->cart->clear_items;

    # Delete double post check token
    $self->c->token->clear;

    return;
}

sub get {
    my $self = shift;

    my $checkout = $self->controller->stash('checkout');
    return $self->_load if !$checkout;

    return $checkout;
}

sub reset { return shift->_create_new }

sub save {
    my $self = shift;

    my $checkout = $self->controller->stash('checkout');
    return if !$checkout;

    return $self->_update($checkout);
}

sub _create_new {
    my $self = shift;

    my $checkout = $self->factory('entity-checkout')->construct();

    # Create Sales Order
    my $sales_order = $checkout->sales_orders->append_new('entity-sales_order');

    # Create Shipment
    $sales_order->shipments->append_new(
        'entity-shipment' => {
            price    => $self->service('price')->create_object,
            tax_rule => $self->service('tax')->get_rule,
        }
    );

    $self->_update($checkout);
    $self->controller->stash( checkout => $checkout );
    return $checkout;
}

sub _load {
    my $self = shift;

    my $data = $self->server_session->data('checkout');
    return $self->_create_new if !$data;

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

Yetie::Service::Checkout::Base

=head1 SYNOPSIS

    use Role::Tiny::With;

    with 'Yetie::Service::Checkout::Base';

    ...

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Checkout::Base> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Checkout::Base> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<delete>

=head2 C<destroy>

=head2 C<get>

=head2 C<reset>

=head2 C<save>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
