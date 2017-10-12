package Markets::Service::Cart;
use Mojo::Base 'Markets::Service';

sub add_item {
    my ( $self, $args ) = @_;

    # NOTE: APIで利用する場合にproductがstashに無い場合は生成する。
    # productをMojo::Cache等でキャッシュするか？
    # キャッシュする場合はservice('product')->load_entity()等としてキャッシュを使うようにする
    # fileキャッシュで全てのproductのキャッシュを生成するのもありか？
    my $product = $self->controller->stash('product');
    $product = $self->controller->service('product')->create_entity( $args->{product_id} ) unless $product;

    $args->{product_title} = $product->title;
    $args->{price}         = $product->price;

    my $item = $self->controller->factory('entity-selling_item')->create($args);
    return $self->controller->helpers->cart->add_item($item);
}

sub create_entity {
    my $self = shift;

    my $cart      = $self->controller->server_session->cart;
    my $cart_data = $cart->data;
    $cart_data->{cart_id} = $cart->cart_id;

    return $self->app->factory('entity-cart')->create($cart_data);
}

# NOTE: とりあえず全てのshipping_itemsを戻すlogicのみ実装
sub revert_shipping_item {
    my $self = shift;

    # 全てのshipping_itemsをカートに戻す
    my $cart = $self->controller->cart;
    $cart->shipments->each(
        sub {
            my ( $shipment, $index ) = @_;
            $_->shipping_items->each(
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

Markets::Service::Cart - Application Service Layer

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Cart> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Cart> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<add_item>

    my $cart = $c->service('cart')->add_item( $product, \%params);

Return L<Markets::Domain::Entity::Cart> object.

=head2 C<create_entity>

    my $cart = $c->service('cart')->create_entity();

Return L<Markets::Domain::Entity::Cart> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
