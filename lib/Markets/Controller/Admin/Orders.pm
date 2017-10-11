package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

sub delete {
    my $self = shift;

    my $form = $self->form_set();    # admin-orders-delete
    return $self->render() unless $form->has_data;

    say 'form ok' if $form->validate;

    my $shipment_id = $form->param('id');

    # shipmentが1つの場合はorderを削除する。複数の場合はshipmentを削除する。
    my $rs       = $self->app->schema->resultset('Sales::Order::Shipment');
    my $shipment = $rs->find($shipment_id);

    # NOTE: 400 Bad Request が適切
    return $self->reply->not_found unless $shipment;

    my $order_header_id = $shipment->order_header_id;
    my $cnt = $rs->search( { order_header_id => $order_header_id } )->count;
    if ( $cnt > 1 ) {    # delete shipment
        $shipment->delete;
    }
    else {               # delete order
        my $order = $self->app->schema->resultset('Sales::OrderHeader')->find($order_header_id);
        $order->delete;
    }

    return $self->redirect_to('RN_admin_orders');
}

sub detail {
    my $self = shift;

    my $shipment_id = $self->stash('id');

    # eg.
    # my $order = $self->factory('entity-order')->create({});

    # bad!
    my $rs       = $self->app->schema->resultset('Sales::Order::Shipment');
    my $shipment = $rs->find($shipment_id);
    return $self->reply->not_found unless $shipment;

    $self->stash( shipment => $shipment );
    $self->render();
}

# NOTE: Catalog::Checkoutに関連する実装がある。
# また、管理者注文も考慮する必要がある。
sub edit {
    my $self     = shift;
    my $shipment_id = $self->stash('id');

    use DDP;
    my $rs = $self->app->schema->resultset('Sales::Order::Shipment');


    # my $schema = $self->app->schema;

    # my $order_rs          = $schema->resultset('Order')->search( { id => $shipment_id } );
    # my $order_rs = $schema->resultset('Order')->find($shipment_id);
    # p $order_rs;
    # my $shipments_rs = $order_rs->related_resultset('shipments');
    # p $shipments_rs;
    # my $shipping_items_rs = $shipments_rs->related_resultset('shipping_items');
    # p $shipping_items_rs;

    # my $order = $order_rs->hashref_array;
    # p $order;
    # my $shipments = $shipments_rs->hashref_array;
    # p $shipments;
    # my $shipping_items = $shipping_items_rs->hashref_array;
    # p $shipping_items;

    # my $rs = $self->app->schema->resultset('Order::Shipment');
    # my @shipments = $rs->search( { order_id => $shipment_id } )->all;

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

    return $self->render();
}

sub index {
    my $self = shift;

    # bad!
    my $schema = $self->app->schema;
    my $itr    = $schema->resultset('Sales::Order::Shipment')->search(
        {},
        {
            page => 1,
            row  => 3,

            # order_by => { -desc => 'order_header_id' },
            prefetch => { order_header => 'billing_address' },

            # prefetch => [{ order_header => 'postal_address' }, 'shipping_address' ],
        }
    );

    $self->stash( itr => $itr );
    $self->render();
}

1;
