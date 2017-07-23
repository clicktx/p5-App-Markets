package Markets::Controller::Catalog::Checkout;
use Mojo::Base 'Markets::Controller::Catalog';

sub index {
    my $self = shift;

    my $form = $self->form_set('checkout');
    return $self->render() unless $form->has_data;

    $self->redirect_to('RN_checkout_address');
}

sub address {
    my $self = shift;

    my $form = $self->form_set('checkout');

    # e.g.
    $form->field('billing_address.line1')->default_value('ogikubo');
    $form->field('shipping_address.line1')->default_value('kamiizumi');

    return $self->render() unless $form->has_data;

    if ( $form->validate ) {

        # billing address
        my $billing_address = $form->param('billing_address.line1');
        $self->cart->billing_address->line1($billing_address);

        # shipping address
        my $shipping_address = $form->param('shipping_address.line1');
        my $shipments        = $self->cart->shipments;
        $shipments->[0]->shipping_address->line1($shipping_address);

        return $self->redirect_to('RN_checkout_shipping');
    }

    $self->render();
}

sub shipping {
    my $self = shift;

    my $form = $self->form_set('checkout');
    return $self->render() unless $form->has_data;

    return $self->render() unless $form->validate;

    # shipping address
    # 商品をshipmentに移動
    # cart.itemsからitemを減らす。shipment.shipping_itemsを増やす
    # 本来は数量を考慮しなくてはならない
    # $item.quantityが0になった場合の動作はどうする？
    my $cart = $self->cart;
    $cart->items->each(
        sub {
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

    return $self->redirect_to('RN_checkout_confirm');
}

#sub payment { }
# sub billing {
#     my $self = shift;
#     $self->render();
# }

sub confirm {
    my $self = shift;
    $self->render();
}

sub complete_validate {
    my $self = shift;

    # NOTE: itemsに商品がある場合 or shipping_itemsが1つも無い場合はcomplete出来ない。
    my $cart = $self->cart;
    return $self->redirect_to('RN_cart') if $cart->count('items') or !$cart->count('all_shipping_items');

    # Make order data
    my $order = $cart->to_order_data;

    # Customer id
    # ログイン購入
    my $customer_id = $self->server_session->data('customer_id');
    if ($customer_id) {
        $order->{customer} = { id => $customer_id };
    }
    else {
        # ゲスト購入
        # emailからcustomer_idを算出？新規顧客の場合はcustomer作成
        $order->{customer} = {};
    }

    # Address正規化
    my $schema_address = $self->app->schema->resultset('Address');

    # billing_address
    my $billing_address = $schema_address->find( { line1 => $order->{billing_address}->{line1} } );
    $order->{billing_address} = { id => $billing_address->id } if $billing_address;

    # shipping_address
    foreach my $shipment ( @{ $order->{shipments} } ) {
        my $result = $schema_address->find( { line1 => $shipment->{shipping_address}->{line1} } );
        next unless $result;
        my $shipping_address_id = $result->id;
        $shipment->{shipping_address} = { id => $shipping_address_id };
    }
    use DDP;
    p $order;    # debug

    # Store order
    my $schema = $self->app->schema;
    my $cb     = sub {

        # Order
        # $order->{order_number} = $schema->sequence('Order');
        # $schema->resultset('Order')->create($order);    # NOTE: itemsはbulk insert されない
        $schema->resultset('Sales::OrderHeader')->create($order);

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
    # cartクリア（再生成）
    my $newcart = $self->factory('entity-cart')->create( {} );
    $self->cart_session->data( $newcart->to_data );

    # redirect_to thank you page
    # $self->render();
    $self->redirect_to('RN_checkout_complete');
}

sub complete {
    my $self = shift;
    $self->render();
}

1;
