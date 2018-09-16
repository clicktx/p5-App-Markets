package Yetie::Controller::Catalog::Checkout;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    # Redirect logged-in customer
    # return $c->redirect_to('RN_checkout_shipping_address') if $c->is_logged_in;
    return $c->review_handler if $c->is_logged_in;

    # Guest or a customer not logged in
    my $form = $c->form('checkout-index');
    $c->flash( ref => 'RN_checkout' );
    return $c->render() unless $form->has_data;

    # Check guest email
    # NOTE: 登録済みの顧客ではないか？
    # 認証済みのメールアドレスか？
    $form->do_validate;
    my $email = $c->factory('value-email')->construct( value => $form->param('guest-email') );
    $c->cart->email($email);

    return $c->render();
}

# handler?
# - Select a shipping address
# - (Choose where to ship each item)
#   - Choose your delivery options
# - Select a payment method
# - Choose a billing address
# - Review your order
sub review_handler {
    my $c = shift;

    return $c->redirect_to('RN_checkout_shipping_address')

      # unless $c->cart->shipments->has_shipping_address;
      # unless $c->cart->has_shipping_address;
      unless 0;

    return $c->redirect_to('RN_checkout_confirm');
}

sub shipping_address {
    my $c = shift;

    my $form        = $c->form('checkout-select_address');
    my $customer_id = $c->server_session->customer_id;

    my $addresses = $c->service('customer')->get_shipping_addresses($customer_id);
    $c->stash( addresses => $addresses );

    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $no       = $form->param('select_address');
    my $selected = $addresses->get($no);

    # 正規に選択されなかった
    return $c->render() unless $selected;

    # NOTE: 1箇所のみに配送の場合
    # 複数配送の場合は先に配送先を複数登録しておく？別コントローラが良い？
    # shipment objectを生成して配列にpushする必要がある。
    # my $shipment = $c->factory('entity-shipment')->create( shipping_address => $selected->address->to_data );
    # $cart->add_shipment($shipment);
    my $cart = $c->cart;
    $cart->update_shipping_address($selected);

    # NOTE: 複数配送を使うかのpreference
    if ( $c->pref('can_multiple_shipments') ) {
        say 'multiple shipment is true';
    }
    else {
        say 'multiple shipment is false';
    }

    # shipping address
    # 商品をshipmentに移動
    # cart.itemsからitemを減らす。shipment.itemsを増やす
    # 本来は数量を考慮しなくてはならない
    # $item.quantityが0になった場合の動作はどうする？
    my $cart = $c->cart;
    $cart->items->each(
        sub {
            # カートitemsから削除
            my $item = $cart->remove_item( $_->id );

            # 配送itemsに追加
            $cart->add_shipping_item( 0, $item );
        }
    );

    # NOTE: 移動や追加をした際にis_modifiedをどのobjectに行うか
    # $cart->is_modified(1)? しか使わなければ実行時間は早く出来る。
    # Entity::Cart::is_modifiedも考慮して実装しよう

    # return $c->redirect_to('RN_checkout_delivery_option');
    return $c->redirect_to('RN_checkout_billing_address');
}

sub delivery_option {
    my $c = shift;
    return $c->redirect_to('RN_checkout_payment_method');
}

sub payment_method {
    my $c = shift;
    return $c->redirect_to('RN_checkout_billing_address');
}

sub billing_address {
    my $c = shift;

    my $form        = $c->form('checkout-select_address');
    my $customer_id = $c->server_session->customer_id;

    my $addresses = $c->service('customer')->get_billing_addresses($customer_id);
    $c->stash( addresses => $addresses );

    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    my $no       = $form->param('select_address');
    my $selected = $addresses->get($no);

    # 正規に選択されなかった
    return $c->render() unless $selected;

    my $cart = $c->cart;
    $cart->update_billing_address($selected);

    return $c->redirect_to('RN_checkout_confirm');
}

sub confirm {
    my $c = shift;

    my $form = $c->form('checkout-confirm');
    return $c->render() unless $form->has_data;

    return $c->render() unless $form->do_validate;

    # checkout complete
    $c->complete_validate;
}

sub complete_validate {
    my $c = shift;

    # NOTE: itemsに商品がある場合 or shipment.itemsが1つも無い場合はcomplete出来ない。
    my $cart = $c->cart;
    return $c->redirect_to('RN_cart') if $cart->count('items') or !$cart->count('all_shipping_items');

    # Make order data
    my $order = $cart->to_order_data;

    # Customer id
    # ログイン購入
    my $customer_id = $c->server_session->data('customer_id');
    if ($customer_id) {
        $order->{customer} = { id => $customer_id };
    }
    else {
        # ゲスト購入
        # emailからcustomer_idを算出？新規顧客の場合はcustomer作成
        $order->{customer} = {};
    }

    # Address正規化
    my $schema_address = $c->app->schema->resultset('Address');

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
    $order->{orders} = delete $order->{shipments};

    use DDP;
    p $order;    # debug

    # Store order
    my $schema = $c->app->schema;
    my $cb     = sub {

        # Order
        # $order->{order_number} = $schema->sequence('Order');
        # $schema->resultset('Order')->create($order);    # NOTE: itemsはbulk insert されない
        $schema->resultset('Sales')->create($order);

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

    use Try::Tiny;
    try {
        $schema->txn_do($cb);
    }
    catch {
        $schema->txn_failed($_);
    };

    # cart sessionクリア
    # cartクリア（再生成）
    my $newcart = $c->factory('entity-cart')->construct( {} );
    $c->cart_session->data( $newcart->to_data );

    # redirect_to thank you page
    # $c->render();
    $c->redirect_to('RN_checkout_complete');
}

sub complete {
    my $c = shift;
    $c->render();
}

1;
