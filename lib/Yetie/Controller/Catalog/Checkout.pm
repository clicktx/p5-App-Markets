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

    my $customer_id = $c->server_session->customer_id;
    my $addresses   = $c->service('customer')->get_shipping_addresses($customer_id);
    $c->stash( addresses => $addresses );

    my $form_select_address = $c->form('checkout-select_address');
    my $form_set_address    = $c->form('shipping_address');
    return $c->render() unless $form_select_address->has_data;

    $form_select_address->do_validate;
    my $no       = $form_select_address->param('select_address');
    my $selected = $addresses->get($no);

    # Select Address
    if ($selected) {
        $c->cart->set_shipping_address($selected);
        return $c->confirm_handler;
    }

    # Set Address
    $form_set_address->do_validate;
    return $c->render() unless $form_set_address->do_validate;

    my $set_address = $c->factory('entity-address')->construct( $form_set_address->params->to_hash );
    $c->cart->set_shipping_address($set_address);

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

    my $customer_id = $c->server_session->customer_id;
    my $addresses   = $c->service('customer')->get_billing_addresses($customer_id);
    $c->stash( addresses => $addresses );

    my $form_select_address = $c->form('checkout-select_address');
    my $form_set_address    = $c->form('billing_address');
    return $c->render() unless $form_select_address->has_data;

    $form_select_address->do_validate;
    my $no       = $form_select_address->param('select_address');
    my $selected = $addresses->get($no);

    # Select Address
    if ($selected) {
        $c->cart->set_billing_address($selected);
        return $c->confirm_handler;
    }

    # Set Address
    $form_set_address->do_validate;
    return $c->render() unless $form_set_address->do_validate;

    my $set_address = $c->factory('entity-address')->construct( $form_set_address->params->to_hash );
    $c->cart->set_billing_address($set_address);
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

    my $cart = $c->cart;
    return $c->redirect_to('RN_cart') unless $cart->total_quantity;

    # billing address
    my $customer_id = $c->server_session->customer_id;
    if ( !$cart->billing_address->id ) {
        my $result = $c->resultset('Address')->find_or_create( $cart->billing_address->to_hash, { key => 'ui_hash' } );
        $cart->billing_address->id( $result->id );

        # Customer Addressに登録
        # NOTE: 自動でアドレス帳に登録するのは良いUXか考慮？
        my $address_types = $c->service('address')->get_address_types;
        $c->resultset('Customer::Address')->find_or_create(
            {
                customer_id     => $customer_id,
                address_id      => $result->id,
                address_type_id => $address_types->get_id_by_name('billing')
            }
        );
    }

    # Make order data
    my $order = $cart->to_order_data;

    # Customer id
    # ログイン購入
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

    # XXX:未完成 Address正規化
    # set時(set_billing_address,set_shipping_address)に正規化を行う？

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
