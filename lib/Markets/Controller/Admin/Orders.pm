package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    # my $orders = $self->model('admin-orders')->list( $cart, { page => 1 } );
    # my $orders = $self->service('admin-orders')->list( { page => 1 } );
    # my $orders = [
    #     { id => 1, date => '2000-1-1' },
    #     { id => 2, date => '2000-2-2' },
    #     { id => 3, date => '2000-3-3' },
    # ];

    # bad!
    my $schema = $self->app->schema;
    my $rs     = $schema->resultset('Order');

    my $itr = $rs->search( {}, { page => 1, row => 10, order_by => { -desc => 'order_no' } } );

    my $orders = [ { id => 1, date => '2000-1-1' }, { id => 2, date => '2000-2-2' }, { id => 3, date => '2000-3-3' }, ];

    $self->stash( it => $itr, orders => $orders );
    $self->render();
}

sub delete {
    my $self = shift;

    my $params = $self->req->params->to_hash;
    my $id = $params->{id};
    $self->app->schema->resultset('Order')->find($id)->delete;

    $self->redirect_to('RN_admin_orders');
}

sub detail {
    my $self     = shift;
    my $order_id = $self->stash('id');

    # bad!
    my $rs = $self->app->schema->resultset('Order::Shipment');
    my @shipments = $rs->search( { order_id => $order_id } )->all;

    $self->stash( shipments => \@shipments );
    $self->render();
}

1;
