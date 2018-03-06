package Yetie::Service::Cart;
use Mojo::Base 'Yetie::Service';

sub add_item {
    my ( $self, $form_params ) = @_;

    # NOTE: APIで利用する場合にproductがstashに無い場合は生成する。
    # productをMojo::Cache等でキャッシュするか？
    # キャッシュする場合はservice('product')->load_entity()等としてキャッシュを使うようにする
    # fileキャッシュで全てのproductのキャッシュを生成するのもありか？
    my $product = $self->controller->stash('product');
    $product = $self->factory('product')->build( $form_params->{product_id} ) unless $product;

    # NOTE: データマッピングは別のメソッドで行うように
    $form_params->{product_title} = $product->title;
    $form_params->{price}         = $product->price;

    my $item = $self->factory('entity-cart-item')->create($form_params);
    return $self->controller->cart->add_item($item);
}

sub find_customer_cart {
    my ( $self, $customer_id ) = @_;

    my $session = $self->controller->server_session;
    my $data = $session->store->load_cart_data($customer_id) || {};
    return $self->factory('entity-cart')->create($data);
}

sub merge_cart {
    my ( $self, $customer_id ) = @_;
    my $c       = $self->controller;
    my $session = $c->server_session;

    my $customer_cart = $self->find_customer_cart($customer_id);
    my $merged_cart   = $c->cart->merge($customer_cart);

    # Remove previous cart from DB
    $session->remove_cart( $session->cart_id );
    return $merged_cart;
}

# NOTE: とりあえず全てのshipment itemsを戻すlogicのみ実装
sub revert_shipping_item {
    my $self = shift;

    # 全てのshipment itemsをカートに戻す
    my $cart = $self->controller->cart;
    $cart->shipments->each(
        sub {
            my ( $shipment, $index ) = @_;
            $_->items->each(
                sub {
                    # 配送itemsから削除
                    my $item = $cart->remove_shipping_item( $index, $_->id );

                    # カートitemsに追加
                    $cart->add_item($item);
                }
            );
        }
    );
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

    my $cart = $c->service('cart')->add_item( $product, \%params);

Return L<Yetie::Domain::Entity::Cart> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
