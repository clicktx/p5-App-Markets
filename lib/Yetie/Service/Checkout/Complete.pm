package Yetie::Service::Checkout::Complete;
use Mojo::Base -role;

sub complete {
    my $self = shift;
    my $c    = $self->c;

    my $checkout = $self->get;

    # XXX:未完成 Address正規化
    # set時(set_billing_address,set_shipping_address)に正規化を行う？

    # shipping address
    my $customer_service = $c->service('customer');
    $checkout->sales_orders->each(
        sub {
            my $sales_order         = shift;
            my $shipping_address_id = $c->service('address')->set_address_id( $sales_order->shipping_address );

            # Add to customer address
            # NOTE: 選択無しでアドレス帳に登録するのは良いUXか考慮
            $customer_service->add_to_address_book($shipping_address_id);
        }
    );

    # billing address
    my $billing_address_id = $c->service('address')->set_address_id( $checkout->billing_address );

    # Add to customer address
    # NOTE: 選択無しでアドレス帳に登録するのは良いUXか考慮
    $customer_service->add_to_address_book($billing_address_id);

    # Make order data
    my $order = $checkout->to_order_data;

    # オーダーデータ整形
    # ログイン購入
    my $customer_id = $c->server_session->customer_id;
    if ($customer_id) {
        $order->{customer} = { id => $customer_id };
    }
    else {
        # ゲスト購入
        # emailからcustomer_idを算出？新規顧客の場合はcustomer作成
        $order->{customer} = {};
    }

    # XXX: WIP ゲスト購入
    delete $order->{email};

    # Add token
    $order->{token} = $c->token->get;

    # Store order
    my $schema = $c->schema;
    my $res;
    my $cb = sub {

        # Order
        # $order->{order_number} = $schema->sequence('Order');
        # $schema->resultset('Order')->create($order);    # NOTE: itemsはbulk insert されない
        $res = $schema->resultset('Sales')->create($order);

        # NOTE:
        # DBIx::Class::ResultSet https://metacpan.org/pod/DBIx::Class::ResultSet#populate
        # chekout の他に注文修正等で使う可能性があるのでresultsetにmethod化しておく？
        # $schema->resultset('Order')->create_with_bulkinsert_items($order);

        # bulk insert
        # my $items = $cart->items->first->to_array;
        # my $order_id = $schema->storage->last_insert_id;
        # my $data = $c->model('item')->to_array( $order_id, $items );
        # $schema->resultset('Order::Item')->populate($data);
    };
    $schema->txn($cb);

    # Delete cart items and token
    $self->destroy;

    # redirect thank you page
    $c->flash( sales_id => $res->id );
    return;
}

1;

__END__

=head1 NAME

Yetie::Service::Checkout::Complete

=head1 SYNOPSIS

    use Role::Tiny::With;

    with 'Yetie::Service::Checkout::Complete';

    ...

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Checkout::Complete> inherits all attributes from L<Mojo::Base> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Checkout::Complete> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<complete>

    $service->complete;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
