package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

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
    return $self->render() if $self->req->method eq 'GET';

    # update address
    return $self->render() unless $form->do_validate;

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
    $params->append( "$address_type.$_" => $order->$address_type->$_ ) for @{$field_names};

    # Collate field keys
    my @field_keys = map { "$address_type.$_" } @{$field_names};
    $self->stash( field_names => \@field_keys );

    return $form;
}

1;
