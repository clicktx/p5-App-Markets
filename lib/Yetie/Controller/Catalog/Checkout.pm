package Yetie::Controller::Catalog::Checkout;
use Mojo::Base 'Yetie::Controller::Catalog';

sub index {
    my $c = shift;

    # Redirect logged-in customer
    return $c->_confirm_handler if $c->is_logged_in;

    # Guest or a customer not logged in
    $c->continue_url('rn.checkout');
    return $c->render();
}

sub shipping_address {
    my $c = shift;

    my $customer_id = $c->server_session->customer_id;
    my $addresses   = $c->service('customer')->get_address_list($customer_id);
    $c->stash( addresses => $addresses );

    my $form = $c->form('customer_address');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Set Address
    my $address = $c->factory('entity-address')->construct( $form->params->to_hash );
    $c->service('checkout')->set_shipping_address($address);

    # NOTE: 1箇所のみに配送の場合
    # 複数配送の場合は先に配送先を複数登録しておく？別コントローラが良い？
    # shipment objectを生成して配列にpushする必要がある。
    # my $shipment = $c->factory('entity-shipment')->create( shipping_address => $selected->address->to_data );
    # $cart->add_shipment($shipment);
    # NOTE: 複数配送を使うかのpreference
    if ( $c->pref('can_multiple_shipments') ) {
        say 'multiple shipment is true';
    }
    else {
        say 'multiple shipment is false';
    }

    return $c->_confirm_handler;
}

sub shipping_address_select {
    my $c = shift;

    $c->_select_address('shipping_address');
    return $c->_confirm_handler;
}

sub delivery_option {
    my $c = shift;
    return $c->redirect_to('rn.checkout.payment_method');
}

sub payment_method {
    my $c = shift;
    return $c->redirect_to('rn.checkout.billing_address');
}

sub billing_address {
    my $c = shift;

    my $customer_id = $c->server_session->customer_id;
    my $addresses   = $c->service('customer')->get_address_list($customer_id);
    $c->stash( addresses => $addresses );

    my $form = $c->form('customer_address');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Set Address
    my $address = $c->factory('entity-address')->construct( $form->params->to_hash );
    $c->service('checkout')->set_billing_address($address);

    return $c->_confirm_handler;
}

sub billing_address_select {
    my $c = shift;

    $c->_select_address('billing_address');
    return $c->_confirm_handler;
}

sub confirm {
    my $c = shift;

    # Confirm checkout
    $c->_confirm_handler();

    my $form = $c->form('checkout-confirm');
    return $c->render() if !$form->has_data;
    return $c->render() if !$form->do_validate;

    # checkout complete
    return $c->_complete_handler;
}

sub complete {
    my $c = shift;
    return $c->render();
}

# handler?
# - Select a shipping address
# - (Choose where to ship each item)
#   - Choose your delivery options
# - Select a payment method
# - Choose a billing address
# - Review your order
sub _confirm_handler {
    my $c = shift;

    # Not has items in cart
    return $c->redirect_to('rn.cart') if !$c->cart->has_item;

    my $checkout_service = $c->service('checkout');
    my $checkout         = $checkout_service->get;

    # Shipping address
    return $c->redirect_to('rn.checkout.shipping_address') if !$checkout->has_shipping_address;

    # FIXME: ship items to one place
    $checkout_service->add_all_cart_items() if !$checkout->shipments->is_multiple;

    # Billing address
    return $c->redirect_to('rn.checkout.billing_address') if !$checkout->has_billing_address;

    # Redirect if not from confirmation page
    if ( $c->stash('action') ne 'confirm' ) { return $c->redirect_to('rn.checkout.confirm') }

    return;
}

sub _complete_handler {
    my $c = shift;

    my $checkout = $c->service('checkout')->get;

    # XXX:未完成 Address正規化
    # set時(set_billing_address,set_shipping_address)に正規化を行う？

    # shipments
    my $customer_service = $c->service('customer');
    $checkout->shipments->each(
        sub {
            my $shipment            = shift;
            my $shipping_address_id = $c->service('address')->set_address_id( $shipment->shipping_address );

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
    my $order = $checkout->get_order_data;

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
    $schema->txn($cb);

    # cart sessionクリア
    # cartクリア（再生成）
    # my $newcart = $c->factory('entity-cart')->construct();
    # $c->cart_session->data( $newcart->to_data );
    $c->cart->clear_items;

    # redirect_to thank you page
    return $c->redirect_to('rn.checkout.complete');
}

sub _select_address {
    my ( $c, $address_type ) = @_;

    my $form = $c->form('checkout-select_address');
    return if !$form->do_validate;

    my $select_no   = $form->param('select_no');
    my $customer_id = $c->server_session->customer_id;
    my $addresses   = $c->service('customer')->get_address_list($customer_id);
    my $selected    = $addresses->get($select_no);
    return if !$selected;

    # Set Address
    # NOTE: set_billing_address or set_shipping_address
    my $checkout = $c->service('checkout')->get;
    my $method   = 'set_' . $address_type;
    $checkout->$method($selected);
    $c->service('checkout')->save;
    return;
}

1;
