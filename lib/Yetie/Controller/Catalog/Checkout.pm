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

    # NOTE: 複数配送を使うかのpreference
    if ( $c->pref('can_multiple_shipments') ) {
        say 'multiple shipment is true';
    }
    else {
        say 'multiple shipment is false';
    }

    return $c->_confirm_handler;
}

sub delivery_option {
    my $c = shift;
    return $c->prg_to('rn.checkout.payment');
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

sub select_address {
    my $c            = shift;
    my $address_type = $c->stash('address_type');

    my $form = $c->form('checkout-select_address');
    return $c->reply->error() if !$form->do_validate;

    # Set address
    my $select_no = $form->param('select_no');
    my $res       = $c->service('checkout')->select_address(
        address_type => $address_type,
        select_no    => $select_no,
    );
    return $c->reply->error() if !$res;

    return $c->_confirm_handler;
}

sub payment {
    my $c = shift;

    my $payment_methods = $c->service('payment')->get_payment_methods();

    # Init Form
    my $form    = $c->form('checkout-payment');
    my $choices = $payment_methods->to_form_choices;
    $form->field('payment_method')->choices($choices);

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Set Payment Method
    my $payment = $payment_methods->get_by_id( $form->param('payment_method') );
    $c->service('checkout')->set_attr( payment_method => $payment );

    return $c->_confirm_handler;
}

sub confirm {
    my $c = shift;

    # Confirm checkout
    return if $c->_confirm_handler();

    # Calculate cart
    # $c->service('checkout')->calculate_shipping_fees();
    $c->service('checkout')->calculate_all();

    my $form = $c->form('checkout-confirm');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Checking double post
    my $res = $c->service('checkout')->validate_double_post();
    return $res if $res;

    # checkout complete
    $c->service('checkout')->complete;
    return $c->prg_to('rn.checkout.complete');
}

sub complete { return shift->render() }

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
    return $c->prg_to('rn.checkout.shipping_address') if !$checkout->has_shipping_address;

    # FIXME: ship items to one place
    $checkout_service->add_all_cart_items() if !$checkout->sales_orders->is_multiple;

    # Billing address
    return $c->prg_to('rn.checkout.billing_address') if !$checkout->has_billing_address;

    # Payment method
    return $c->prg_to('rn.checkout.payment') if !$checkout->has_payment_method;

    # Redirect if not from confirmation page
    if ( $c->stash('action') ne 'confirm' ) { return $c->prg_to('rn.checkout.confirm') }

    return;
}

1;
