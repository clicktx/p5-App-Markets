package Yetie::Controller::Admin::Order::Edit;
use Mojo::Base 'Yetie::Controller::Admin';

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub billing_address {
    my $self     = shift;
    my $order_id = $self->stash('id');

    my $order = $self->service('order')->find_order($order_id);
    $self->stash( content => $order );
    return $self->reply->not_found if $order->is_empty;

    my $form = $self->form('billing_address');

    # $self->form_default_value( $form, $entity );
    $form->field($_)->default_value( $order->billing_address->$_ ) for qw(line1);

    return $self->render() unless $form->has_data;
    $form->do_validate;

    return $self->render();
}

1;
