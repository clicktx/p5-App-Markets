package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

sub items {
    my $self = shift;

    my $order_id = $self->stash('id');
    my $order    = $self->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . 'Edit Items' );
    $self->stash( entity => $order );
    return $self->reply->not_found if $order->is_empty;

    my $form = $self->form('admin-order-edit-item');

    # GET Request
    return $self->render() if $self->req->method eq 'GET';

    # Validation form
    return $self->render() unless $form->do_validate;

    # Update
    my $params = $form->param('item') || {};
    foreach my $key ( keys %{$params} ) {
        my $id = $key;
        $id =~ s/\*//g;
        my $values = $params->{$key};
        $self->resultset('sales-order-item')->search( { id => $id } )->update($values);
    }
    return $self->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub billing_address {
    my $self = shift;
    $self->_edit_address(
        {
            address_type => 'billing_address',
            title        => 'Edit Billing Address',
        }
    );
}

sub shipping_address {
    my $self = shift;
    $self->_edit_address(
        {
            address_type => 'shipping_address',
            title        => 'Edit Shipping Address',
        }
    );
}

sub _edit_address {
    my $self = shift;
    my $args = shift;

    my $order_id = $self->stash('id');
    my $order    = $self->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . $args->{title} );
    $self->stash( entity => $order );
    return $self->reply->not_found if $order->is_empty;

    my $form = $self->_init_form( $args->{address_type} );

    # GET Request
    return $self->render('admin/order/edit/address') if $self->req->method eq 'GET';

    # Validation form
    return $self->render('admin/order/edit/address') unless $form->do_validate;

    # Update address
    my $address_type = $self->stash('action');
    $self->service('address')->store( $form->param($address_type) );

    return $self->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

sub _init_form {
    my ( $self, $address_type ) = @_;

    my $region = 'us';
    my $form   = $self->form($address_type);
    my $order  = $self->stash('entity');

    # Set form default value
    my $field_names = $order->$address_type->field_names($region);
    my $params      = $self->req->params;
    do {
        my $value = $order->$address_type->$_;
        $params->append( "$address_type.$_" => "$value" );
      }
      for @{$field_names};

    # Collate field keys
    my @field_keys = map { "$address_type.$_" } @{$field_names};
    $self->stash( field_names => \@field_keys );

    return $form;
}

1;
