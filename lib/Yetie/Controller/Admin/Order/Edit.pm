package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub billing_address {
    my $order_id = $self->stash('id');
    my $order    = $self->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . 'Edit Billing Address' );
    $self->stash( entity => $order );
    return $self->reply->not_found if $order->is_empty;

    my $form = $self->_init_form('billing_address');

    # GET Request
    return $self->render() if $self->req->method eq 'GET';

    # update address
    return $self->render() unless $form->do_validate;

    return $self->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

sub shipping_address {
    my $self = shift;

    my $order_id = $self->stash('id');
    my $order    = $self->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . 'Edit Shipping Address' );
    $self->stash( entity => $order );
    return $self->reply->not_found if $order->is_empty;

    my $form = $self->_init_form('shipping_address');
    return $self->render() unless $form->has_data;
    return $self->render() unless $form->do_validate;

    # update address
    # ...

    return $self->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

sub _init_form {
    my ( $self, $address_type ) = @_;

    my $region = 'us';
    my $form   = $self->form($address_type);
    my $order  = $self->stash('entity');

    # Set form default value
    my $fields = $order->$address_type->fields($region);
    my $params = $self->req->params;
    $params->append( "$address_type.$_" => $order->$address_type->$_ ) for @{$fields};

    # Collate field keys
    my @field_keys = map { "$address_type.$_" } @{$fields};
    $self->stash( fields => \@field_keys );

    return $form;
}

1;
