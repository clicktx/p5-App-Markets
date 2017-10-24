package Markets::Domain::Factory::Entity::SalesOrder;
use Mojo::Base 'Markets::Domain::Factory';

sub cook {
    my $self = shift;

    # customer
    # my $customer = $self->factory('entity-customer')->create( $self->param('customer') || {} );
    # $self->param( customer => $customer );

    # Aggregate shipments
    # NOTE: code from Factory::Entity::Cart
    my $param = $self->param('shipments') || [ {} ];
    $self->aggregate( 'shipments', 'entity-shipment', $param );
}

sub create {
    my ( $self, $order_header_id ) = ( shift, shift );

   # my $order_header = $self->app->schema->resultset('Sales::OrderHeader')->find(
   #     { id       => $order_header_id },
   #     { prefetch => [ 'customer', 'billing_address', { shipments => [ 'shipping_address', 'shipping_items' ] }, ], },
   # );
    my $order_header = $self->app->schema->resultset('Sales::OrderHeader')->find( { id => $order_header_id } );
    return unless $order_header;

    # my $customer = $self->app->service('customer')->create_entity( customer_id => $order_header->customer_id );
    my $customer = $self->app->factory('entity-customer')->create( $order_header->customer_id );

    # my $billing_address1 = $self->app->factory('entity-address')->create( $order_header->address_id );
    my $billing_address = $self->app->factory('entity-address')->create( $order_header->billing_address );

    # shipments
    my @shipments;
    my $itr = $order_header->shipments;
    while ( my $result = $itr->next ) {

        # my $shipping_address = $self->app->factory('entity-address')->create( $result->address_id );
        my $shipping_address = $self->app->factory('entity-address')->create( $result->shipping_address );
        my $items = $result->shipping_items->to_array( ignore_columns => ['shipment_id'] );

        push @shipments,
          {
            id               => $result->id,
            shipping_address => $shipping_address,
            shipping_items   => $items,
          };
    }

    my $data = {
        id              => $order_header_id,
        customer        => $customer,
        billing_address => $billing_address,
        shipments       => \@shipments,
        created_at      => $order_header->created_at,
        updated_at      => $order_header->updated_at,
    };

    $self->create_entity($data);
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::SalesOrder

=head1 SYNOPSIS

    # In controller
    my $entity = $c->factory('entity-sales_order')->create($order_header_id);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::SalesOrder> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::SalesOrder> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head2 C<create>

    my $entity = $c->factory('entity-sales_order')->create($order_header_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
