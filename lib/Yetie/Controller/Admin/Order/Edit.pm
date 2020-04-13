package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub billing_address {
    my $c = shift;
    return $c->_edit_address(
        {
            title => 'Edit Billing Address',
        }
    );
}

sub items {
    my $c = shift;

    my $order_id = $c->stash('id');
    my $order    = $c->service('order')->find_order($order_id);
    return $c->reply->not_found if $order->is_empty;

    # Init form
    my $form = $c->form('admin-order-edit-item');

    # Page
    my $page = $c->factory('entity-page')->construct(
        title => 'Edit Items',
        form  => $form,
    );

    # Stash
    $c->stash( page => $page, order => $order );

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Store to DB
    my $param_list = $form->scope_param('item') || [];
    $c->service('order')->store_items( $order, $param_list );

    my $url = $c->url_for( 'rn.admin.order.index', order_id => $order_id )->fragment('items');
    return $c->redirect_to($url);
}

sub shipping_address {
    my $c = shift;
    return $c->_edit_address(
        {
            title => 'Edit Shipping Address',
        }
    );
}

sub _edit_address {
    my $c    = shift;
    my $args = shift;

    my $order_id = $c->stash('id');
    my $order    = $c->service('order')->find_order($order_id);
    return $c->reply->not_found if $order->is_empty;

    # Init form
    my $address = $order->{ $c->stash('action') };
    my $form    = $c->_init_form($address);

    # Page
    my $page = $c->factory('entity-page')->construct(
        title => $args->{title},
        form  => $form,
    );

    # Stash
    $c->stash( page => $page, order => $order );
    $c->template('admin/order/edit/address');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    # Update address
    $c->service('address')->update_address( $form->params->to_hash );

    my $url = $c->url_for( 'rn.admin.order.index', order_id => $order_id )->fragment( $c->stash('action') );
    return $c->redirect_to($url);

}

sub _init_form {
    my ( $c, $address ) = @_;

    my $form = $c->form('customer_address');

    # Set select box options
    my $country_code = $address->country_code;
    $c->service('address')->init_form( $form, $country_code );

    # Set default value
    my $region      = 'us';                             # FIXME:
    my $field_names = $address->field_names($region);
    my $params      = $c->req->params;
    foreach my $key ( @{$field_names} ) {
        my $value = $address->$key;
        $params->append( $key => "$value" );
    }
    $c->stash( field_names => $field_names );
    return $form;
}

1;
