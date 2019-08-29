package Yetie::Controller::Admin::Order;
use Mojo::Base 'Yetie::Controller::Admin';

sub index {
    my $c = shift;

    my $order_id = $c->stash('id');
    my $order    = $c->service('order')->find_order($order_id);
    return $c->reply->not_found if $order->is_empty;

    # Page
    my $page = $c->factory('entity-page')->construct( title => 'Order Details', );
    return $c->render( page => $page, order => $order );
}

sub create {
    my $c = shift;
    return $c->render();
}

sub duplicate {
    my $c = shift;

    my $order_id = $c->stash('id');
    my $order    = $c->service('order')->find_order($order_id);
    return $c->reply->not_found if $order->is_empty;

    my $form = $c->form('admin-order');

    # 複数配送の場合はどうするか？
    use DDP;
    p $form;

    # オーダーをすべてコピー
    # my $order    = $c->schema->resultset('Sales')->find_by_order_id($order_id)->copy;
    # p $order;

    # my $order = $c->schema->resultset('SalesOrder')->find_by_id($order_id);

    # return $c->redirect_to('rn.admin.orders');
    # $c->stash( entity => $order );
    return $c->render('admin/order/create');
}

# NOTE: 決済履歴やポイント履歴等が絡むと厄介なことになりそう
sub trash {
    my $c = shift;

    # Initialize form
    my $form = $c->form('admin-order');

    # Get request
    return $c->render() if $c->is_get_request;

    # Validation form
    return $c->render() if !$form->do_validate;

    my $order_id = $form->param('id');
    my $rs       = $c->app->schema->resultset('SalesOrder');
    my $order    = $rs->find($order_id);
    return $c->reply->error() if !$order;

    $order->update( { trashed_at => $c->date_time->now } );
    return $c->redirect_to('rn.admin.orders');
}

1;
