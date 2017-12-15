package Yetie::Controller::Admin::Order;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $self = shift;

    my $order_id = $self->stash('id');
    my $order    = $self->schema->resultset('Sales::Order')->find_by_id($order_id);
    return $self->reply->not_found unless $order;

    $self->stash( order => $order );
    $self->render();
}

sub create {
    my $self = shift;
    return $self->render();
}

sub delete {
    my $self = shift;

    my $form = $self->form('admin-order');
    return $self->render() unless $form->has_data;

    say 'form ok' if $form->do_validate;

    my $order_id = $form->param('id');

    # shipmentが1つの場合はorderを削除する。複数の場合はshipmentを削除する。
    my $rs    = $self->app->schema->resultset('Sales::Order');
    my $order = $rs->find($order_id);

    # NOTE: 400 Bad Request が適切
    return $self->reply->not_found unless $order;

    my $sales_id = $order->sales_id;
    my $cnt = $rs->search( { sales_id => $sales_id } )->count;
    if ( $cnt > 1 ) {    # delete shipment
        $order->delete;
    }
    else {               # delete order
        my $order = $self->app->schema->resultset('Sales')->find($sales_id);
        $order->delete;
    }

    return $self->redirect_to('RN_admin_orders');
}

sub duplicate {
    my $self = shift;

    # my $order_id = $self->stash('id');
    my $form = $self->form('admin-order');

    # 複数配送の場合はどうするか？
    use DDP;
    p $form;

    # オーダーをすべてコピー
    # my $order    = $self->schema->resultset('Sales')->find_by_order_id($order_id)->copy;
    # p $order;

    # my $order = $self->schema->resultset('Sales::Order')->find_by_id($order_id);
    # p $order->sales->as_fdat;
    # p $order->as_fdat;
    # $order->items->each( sub { p $_->as_fdat } );

    # return $self->redirect_to('RN_admin_orders');
    return $self->render('admin/order/edit');
}

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub edit {
    my $self = shift;

    my $order_id = $self->stash('id');
    my $order    = $self->schema->resultset('Sales')->find_by_order_id($order_id);
    use DDP;
    p $order;
    my $e = $self->factory('order')->create();
    p $e;

    # my $rs = $self->app->schema->resultset('Sales::Order');

    # my $schema = $self->app->schema;

    # my $order_rs          = $schema->resultset('Order')->search( { id => $order_id } );
    # my $order_rs = $schema->resultset('Order')->find($order_id);
    # p $order_rs;
    # my $orders_rs = $order_rs->related_resultset('shipments');
    # p $orders_rs;
    # my $items_rs = $orders_rs->related_resultset('items');
    # p $items_rs;

    # my $order = $order_rs->hashref_array;
    # p $order;
    # my $orders = $orders_rs->hashref_array;
    # p $orders;
    # my $items = $items_rs->hashref_array;
    # p $items;

    # my $rs = $self->app->schema->resultset('Order::Shipment');
    # my @shipments = $rs->search( { order_id => $order_id } )->all;

    #####
    # foreach my $order (@shipments) {
    #     p $order->result_source->resultset->hashref_rs;
    # p $order->hashref_rs;
    # my $items = $order->items;
    # p $items;
    # }

    # while (my $order = $array->next) {
    #
    #     p $order;
    #
    #     # my $items = $order->items;
    #     # p $items;
    #
    #     my $items = $order->items->hashref_array;
    #     p $items;
    # }

    #####

    return $self->render();
}

1;
