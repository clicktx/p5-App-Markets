package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

sub items {
    my $c = shift;

    my $order_id = $c->stash('id');
    my $order    = $c->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . 'Edit Items' );
    $c->stash( entity => $order );
    return $c->reply->not_found if $order->is_empty;

    my $form = $c->form('admin-order-edit-item');

    # GET Request
    return $c->render() if $c->req->method eq 'GET';

    # Validation form
    return $c->render() unless $form->do_validate;

    # Update
    my $params = $form->param('item') || {};
    foreach my $key ( keys %{$params} ) {
        my $id = $key;
        $id =~ s/\*//g;
        my $values = $params->{$key};
        $c->resultset('Sales::Order::Item')->search( { id => $id } )->update($values);
    }
    return $c->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub billing_address {
    my $c = shift;
    $c->_edit_address(
        {
            address_type => 'billing_address',
            title        => 'Edit Billing Address',
        }
    );
}

sub shipping_address {
    my $c = shift;
    $c->_edit_address(
        {
            address_type => 'shipping_address',
            title        => 'Edit Shipping Address',
        }
    );
}

sub _edit_address {
    my $c    = shift;
    my $args = shift;

    my $order_id = $c->stash('id');
    my $order    = $c->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . $args->{title} );
    $c->stash( entity => $order );
    return $c->reply->not_found if $order->is_empty;

    my $form = $c->_init_form( $args->{address_type} );

    # GET Request
    return $c->render('admin/order/edit/address') if $c->req->method eq 'GET';

    # Validation form
    return $c->render('admin/order/edit/address') unless $form->do_validate;

    # Update address
    $c->service('address')->update_address( $form->params->to_hash );

    return $c->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

sub _init_form {
    my ( $c, $address_type ) = @_;

    my $region = 'us';
    my $form   = $c->form($address_type);
    my $order  = $c->stash('entity');

    # Set form default value
    my $field_names = $order->$address_type->field_names($region);
    my $params      = $c->req->params;
    foreach my $key ( @{$field_names} ) {
        my $value = $order->$address_type->$key;
        $params->append( $key => "$value" );
    }
    $c->stash( field_names => $field_names );
    return $form;
}

1;
