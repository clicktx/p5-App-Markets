package Markets::Controller::Catalog::Checkout;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;
    $self->render();
}

sub adress {
    my $self = shift;
    $self->render();
}

sub shipping {
    my $self = shift;

    my $cart = $self->cart;

    # shipping address
    # NOTE: 実際にはaddressで作成されているはず
    {
        my $data = { shipping_address => 'kamiizumi' };
        my $shipment = $self->app->factory( 'entity-shipment', %{$data} );

        use Markets::Domain::Collection qw/collection/;
        $cart->shipments( collection($shipment) ) unless $cart->shipments->size;
    }

    # 商品をshipmentに移動
    # cart.itemsからitemを減らす。shipment.shipping_itemsを増やす
    # 本来は数量を考慮しなくてはならない
    # $item.quantityが0になった場合の動作はどうする？
    $cart->items->each(
        sub {
            use DDP;

            # カートitemsから削除
            my $item = $cart->remove_item( $_->id );

            # 配送itemsに追加
            # $cart->add_shipping_item($item => $shipment);
            $cart->add_shipping_item($item);
        }
    );

    # NOTE: 移動や追加をした際にis_modifiedをどのobjectに行うか
    # $cart->is_modified(1)? しか使わなければ実行時間は早く出来る。
    # Entity::Cart::is_modifiedも考慮して実装しよう

    $self->render();
}

#sub payment { }
sub billing {
    my $self = shift;
    $self->render();
}

sub confirm {
    my $self = shift;
    $self->render();
}

sub complete {
    my $self = shift;

    # TODO: model化する
    # itemsが無い場合は実行しない
    my $cart = $self->cart;

# NOTE: itemsに商品がある場合、shipping_itemsが1つも無い場合はcomplete出来ない。
    $self->redirect_to('RN_cart') if $cart->items->size;

    # $cart->count('items') or $cart->count('shipping_items')

    # cartデータからorderデータ作成
    my $order = { billing_address => 'ogikubo' };
    my $customer_id = $self->server_session->data('customer_id');
    $order->{customer_id} = $customer_id;

    # items
    # NOTE: 実際にはshipmentsは作成されているはず
    # my $shipments = [ { shipping_address => 'kamiizumi' } ];
    # $shipments->[0]->{items} = $cart_data->{items};
    $order->{shipments} = $cart->to_data->{shipments};
    use DDP;
    p $order;

    # Store order
    my $schema = $self->app->schema;
    my $cb     = sub {

        # Order
        $order->{order_no} = $schema->sequence('Order');
        $schema->resultset('Order')->create($order);

        # Items
        # $schema->resultset('Order')->create($order); # itemsがbulk insert されない

# NOTE:
# DBIx::Class::ResultSet https://metacpan.org/pod/DBIx::Class::ResultSet#populate
# chekout の他に注文修正等で使う可能性があるのでresultsetにmethod化しておく？
# $schema->resultset('Order')->create_with_bulkinsert_items($order);

        # bulk insert
        # my $items = $cart->items->first->to_array;
        # my $order_id = $schema->storage->last_insert_id;
        # my $data = $self->model('item')->to_array( $order_id, $items );
        # $schema->resultset('Order::Item')->populate($data);
    };

    use Try::Tiny;
    try {
        $schema->txn_do($cb);
    }
    catch {
        $self->model('common')->dbic_txn_failed($_);
    };

    # cart sessionクリア
    $cart->clear;

    # redirect_to thank you page
    $self->render();
}

1;
