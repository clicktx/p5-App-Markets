package Markets::Controller::Admin::Orders;
use Mojo::Base 'Markets::Controller::Admin';

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

sub edit {
    my $self = shift;
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
