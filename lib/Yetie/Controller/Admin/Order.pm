package Yetie::Controller::Admin::Order;
use Mojo::Base 'Yetie::Controller::Admin';

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

sub details {
    my $self     = shift;
    my $order_id = $self->stash('id');

    my $order = $self->service('order')->find_order($order_id);
    return $self->reply->not_found if $order->is_empty;

    $self->stash( domain => $order );
    $self->render();
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
    my $self     = shift;
    my $order_id = $self->stash('id');

    my $order = $self->service('order')->find_order($order_id);
    return $self->reply->not_found if $order->is_empty;

    my $form = $self->form('address');

    # $self->form_default_value( $form, $entity );
    $form->field($_)->default_value( $order->billing_address->$_ ) for qw(line1);
    use DDP;
    p $form;

    $self->stash( domain => $order );
    $self->render();

    return $self->render();
}

1;
