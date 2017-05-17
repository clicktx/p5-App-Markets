package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

sub index {
    my $self = shift;

    # eg.
    # my $order = $self->factory( 'entity-order', {} )->create;

    # bad!
    my $schema = $self->app->schema;
    my $itr = $schema->resultset('Sales::Order::Shipment')->search(
        {},
        {
            page     => 1,
            row      => 10,
            # order_by => { -desc => 'order_header_id' },
            prefetch => { order_header => 'billing_address' },
            # prefetch => [{ order_header => 'postal_address' }, 'shipping_address' ],
        }
    );

    $self->stash( itr => $itr );
    $self->render();
}

sub delete {
    my $self = shift;

    my $params = $self->req->params->to_hash;
    my $id     = $params->{id};
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

sub edit {
    my $self     = shift;
    my $order_id = $self->stash('id');

    use DDP;
    my $schema = $self->app->schema;

    # my $order_rs          = $schema->resultset('Order')->search( { id => $order_id } );
    my $order_rs = $schema->resultset('Order')->find($order_id);
    p $order_rs;
    my $shipments_rs = $order_rs->related_resultset('shipments');
    p $shipments_rs;
    my $shipping_items_rs = $shipments_rs->related_resultset('shipping_items');
    p $shipping_items_rs;

    # my $order = $order_rs->hashref_array;
    # p $order;
    # my $shipments = $shipments_rs->hashref_array;
    # p $shipments;
    # my $shipping_items = $shipping_items_rs->hashref_array;
    # p $shipping_items;

    # my $rs = $self->app->schema->resultset('Order::Shipment');
    # my @shipments = $rs->search( { order_id => $order_id } )->all;

    #####
    # foreach my $shipment (@shipments) {
    #     p $shipment->result_source->resultset->hashref_rs;
    # p $shipment->hashref_rs;
    # my $items = $shipment->shipping_items;
    # p $items;
    # }

    # while (my $shipment = $array->next) {
    #
    #     p $shipment;
    #
    #     # my $shipping_items = $shipment->shipping_items;
    #     # p $shipping_items;
    #
    #     my $items = $shipment->shipping_items->hashref_array;
    #     p $items;
    # }

    #####

    $self->render();
}

1;
