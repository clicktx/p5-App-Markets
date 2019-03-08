package Yetie::Service::Cart;
use Mojo::Base 'Yetie::Service';

sub add_item {
    my ( $self, $form_params ) = @_;

    # NOTE: APIで利用する場合にproductがstashに無い場合は生成する。
    # productをMojo::Cache等でキャッシュするか？
    # キャッシュする場合はservice('product')->load_entity()等としてキャッシュを使うようにする
    # fileキャッシュで全てのproductのキャッシュを生成するのもありか？
    my $product = $self->controller->stash('product');
    $product = $self->service('product')->find_product( $form_params->{product_id} ) unless $product;

    # NOTE: データマッピングは別のメソッドで行うように
    $form_params->{product_title} = $product->title;
    $form_params->{price}         = $product->price;

    my $item = $self->factory('entity-cart_item')->construct($form_params);
    return $self->controller->cart->add_item($item);
}

sub find_cart {
    my ( $self, $cart_id ) = @_;

    my $session = $self->controller->server_session;
    my $data = $session->store->load_cart_data($cart_id) || {};
    return $self->factory('entity-cart')->construct($data);
}

sub merge_cart {
    my ( $self, $customer_id ) = @_;
    my $c       = $self->controller;
    my $session = $c->server_session;

    my $customer_cart = $self->find_cart($customer_id);
    return $customer_cart unless $c->cart;    # NOTE: necessary remember_me login

    my $merged_cart = $c->cart->merge($customer_cart);
    $session->remove_cart( $session->cart_id );
    return $merged_cart;
}

sub set_address_id {
    my ( $self, $address ) = @_;

    my $result = $self->resultset('Address')->find_or_create_address( $address->to_hash );
    $address->id( $result->id );
}

1;
__END__

=head1 NAME

Yetie::Service::Cart - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Cart> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Cart> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<add_item>

    my $cart = $service->add_item( $product, \%params);

Return L<Yetie::Domain::Entity::Cart> object.

=head2 C<find_cart>

    my $cart = $service->find_cart($cart_id);

Return L<Yetie::Domain::Entity::Cart> object.

=head2 C<merge_cart>

    my $merged_cart = $service->merge_cart($customer_id);

Return L<Yetie::Domain::Entity::Cart> object.

Merge with saved customer cart.

=head2 C<set_address_id>

    $servece->set_address_id( $cart->billing_address );
    $servece->set_address_id( $cart->shipment->[0]->shipping_address );

Argument L<Yetie::Domain::Entity::Address> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
