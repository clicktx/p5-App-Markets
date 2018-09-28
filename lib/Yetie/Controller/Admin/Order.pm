package Yetie::Controller::Admin::Order;
use Mojo::Base 'Yetie::Controller::Admin';

sub create {
    my $c = shift;
    return $c->render();
}

sub delete {
    my $c = shift;

    my $form = $c->form('admin-order');
    return $c->render() unless $form->has_data;

    say 'form ok' if $form->do_validate;

    my $order_id = $form->param('id');

    # shipmentが1つの場合はorderを削除する。複数の場合はshipmentを削除する。
    my $rs    = $c->app->schema->resultset('Sales::Order');
    my $order = $rs->find($order_id);

    # NOTE: 400 Bad Request が適切
    return $c->reply->not_found unless $order;

    my $sales_id = $order->sales_id;
    my $cnt = $rs->search( { sales_id => $sales_id } )->count;
    if ( $cnt > 1 ) {    # delete shipment
        $order->delete;
    }
    else {               # delete order
        my $order = $c->app->schema->resultset('Sales')->find($sales_id);
        $order->delete;
    }

    return $c->redirect_to('RN_admin_orders');
}

sub details {
    my $c = shift;

    my $order = $c->_find_order;
    return $c->reply->not_found if $order->is_empty;

    $c->stash( entity => $order );
    $c->render();
}

sub duplicate {
    my $c = shift;

    my $order = $c->_find_order;
    return $c->reply->not_found if $order->is_empty;

    my $form = $c->form('admin-order');

    # 複数配送の場合はどうするか？
    use DDP;
    p $form;

    # オーダーをすべてコピー
    # my $order    = $c->schema->resultset('Sales')->find_by_order_id($order_id)->copy;
    # p $order;

    # my $order = $c->schema->resultset('Sales::Order')->find_by_id($order_id);

    # return $c->redirect_to('RN_admin_orders');
    $c->stash( entity => $order );
    return $c->render('admin/order/edit');
}

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub edit {
    my $c = shift;

    my $order = $c->_find_order;
    return $c->reply->not_found if $order->is_empty;

    my $form = $c->form('base-address');

    # $c->form_default_value( $form, $entity );
    $form->field($_)->default_value( $order->billing_address->$_ ) for qw(line1);
    use DDP;
    p $form;

    $c->stash( entity => $order );
    $c->render();

    return $c->render();
}

sub _find_order {
    my $c = shift;

    my $order_id = $c->stash('id');
    $c->service('order')->find_order($order_id);
}

1;
