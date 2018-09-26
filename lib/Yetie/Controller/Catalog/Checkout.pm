package Yetie::Controller::Catalog::Checkout;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    # Redirect logged-in customer
    return $c->confirm_handler if $c->is_logged_in;

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
    $cart->set_shipping_address($selected);

    # NOTE: 複数配送を使うかのpreference
    if ( $c->pref('can_multiple_shipments') ) {
        say 'multiple shipment is true';
    }
    else {
        say 'multiple shipment is false';
    }

    return $c->confirm_handler;
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
    $cart->set_billing_address($selected);

    return $c->confirm_handler;
}

sub confirm {
    my $c = shift;

    $c->confirm_handler;

    my $form = $c->form('checkout-confirm');
    return $c->render() unless $form->has_data;
    return $c->render() unless $form->do_validate;

    # checkout complete
    $c->complete_handler;
}

sub complete {
    my $c = shift;
    $c->render();
}

# handler?
# - Select a shipping address
# - (Choose where to ship each item)
#   - Choose your delivery options
# - Select a payment method
# - Choose a billing address
# - Review your order
sub confirm_handler {
    my $c    = shift;
    my $cart = $c->cart;

    # No items
    return $c->redirect_to('RN_cart') unless $cart->has_item;

    # Shipping address
    return $c->redirect_to('RN_checkout_shipping_address') unless $cart->has_shipping_address;

    # ship items to one place
    $cart->move_items_to_first_shipment if !$cart->has_shipping_item and !$cart->shipments->is_multiple;

    # Billing address
    return $c->redirect_to('RN_checkout_billing_address') unless $cart->has_billing_address;

    # Redirect confirm
    return $c->redirect_to('RN_checkout_confirm') if $c->stash('action') ne 'confirm';
}

sub complete_handler {
    my $c = shift;

    # NOTE: itemsに商品がある場合 or shipment.itemsが1つも無い場合はcomplete出来ない。
    my $cart = $c->cart;
    return $c->redirect_to('RN_cart') unless $cart->total_quantity;

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

    # NOTE: WIP ゲスト購入
    delete $order->{email};

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
    # my $newcart = $c->factory('entity-cart')->construct();
    # $c->cart_session->data( $newcart->to_data );
    $cart->clear_items;

    # redirect_to thank you page
    $c->redirect_to('RN_checkout_complete');
}

1;
