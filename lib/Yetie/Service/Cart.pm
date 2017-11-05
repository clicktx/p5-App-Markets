package Yetie::Service::Cart;
use Mojo::Base 'Yetie::Service';

sub add_item {
    my ( $self, $args ) = @_;

    # NOTE: APIで利用する場合にproductがstashに無い場合は生成する。
    # productをMojo::Cache等でキャッシュするか？
    # キャッシュする場合はservice('product')->load_entity()等としてキャッシュを使うようにする
    # fileキャッシュで全てのproductのキャッシュを生成するのもありか？
    my $product = $self->controller->stash('product');
    $product = $self->controller->factory('product')->build( $args->{product_id} ) unless $product;

    $args->{product_title} = $product->title;
    $args->{price}         = $product->price;

    my $item = $self->controller->factory('entity-selling_item')->create($args);
    return $self->controller->helpers->cart->add_item($item);
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
