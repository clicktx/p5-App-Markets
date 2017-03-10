package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    # bad!
    my $schema = $self->app->schema;
    my $rs     = $schema->resultset('Order');

    my $itr = $rs->search( {}, { page => 1, row => 10, } );

    my $orders = [
        { id => 1, date => '2000-1-1' },
        { id => 2, date => '2000-2-2' },
        { id => 3, date => '2000-3-3' },
    ];

    $self->stash( it => $itr, orders => $orders );
}

sub detail {
    my $self     = shift;
    my $order_id = $self->stash('id');

    # bad!
    my $rs = $self->app->schema->resultset('Order::Item');
    my $itr = $rs->search( { order_id => $order_id } );

    $self->stash( it => $itr );
}

1;
