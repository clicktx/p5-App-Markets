package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub billing_address {
    my $self     = shift;
    my $order_id = $self->stash('id');

    my $order = $self->service('order')->find_order($order_id);
    $order->page_title( $order->page_title . '/' . 'Edit Billing Address' );

    $self->stash( entity => $order );
    return $self->reply->not_found if $order->is_empty;

    # Set default values
    my $region = 'us';
    my $fields = $order->billing_address->fields($region);
    my $form   = $self->form('billing_address');
    my @billing_address_fields;
    do {
        $form->field( "billing_address." . $_ )->default_value( $order->billing_address->$_ );
        push @billing_address_fields, 'billing_address.' . $_;
      }
      for @{$fields};
    $self->stash( fields => \@billing_address_fields );

    return $self->render() unless $form->has_data;
    return $self->render() unless $form->do_validate;

    # update data

    return $self->redirect_to( 'RN_admin_order_details', order_id => $order_id );
}

1;
