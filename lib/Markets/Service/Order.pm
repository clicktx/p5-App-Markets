package Markets::Service::Order;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Sales::OrderHeader') };

sub create_entity {
    my ( $self, $shipment_id ) = @_;

    my $shipment = $self->schema->resultset('Sales::Order::Shipment')->find($shipment_id);
    return unless $shipment;

    my $order_header_id = $shipment->order_header_id;
    my $order_header    = $self->resultset->find(
        { id       => $order_header_id },
        { prefetch => [ 'customer', 'billing_address', { shipments => [ 'shipping_address', 'shipping_items' ] }, ], },
    );

    my $customer = $self->app->service('customer')->create_entity( customer_id => $order_header->customer_id );
    my $billing_address = $self->app->service('address')->create_entity( $order_header->address_id );

    # shipments
    my @shipments;
    my $itr = $order_header->shipments;
    while ( my $result = $itr->next ) {
        my $shipping_address = $self->app->service('address')->create_entity( $result->address_id );
        my %shipment         = (
            id               => $result->id,
            shipping_address => $shipping_address,
        );

        my $items_itr = $result->shipping_items;
        my @items;
        while ( my $res = $items_itr->next ) {
            my %item = (
                id            => $res->id,
                product_id    => $res->product_id,
                product_title => $res->product_title,
                price         => $res->price,
                quantity      => $res->quantity,
            );
            push @items, \%item;
        }
        $shipment{shipping_items} = \@items;
        push @shipments, \%shipment;
    }

    my $data = {
        id              => $order_header->id,
        customer        => $customer,
        billing_address => $billing_address,
        shipments       => \@shipments,
        created_at      => $order_header->created_at,
        updated_at      => $order_header->updated_at,
    };

    return $self->app->factory('entity-sales_order')->create( $data || {} );
}

1;
__END__

=head1 NAME

Markets::Service::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Order> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Order> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $category_tree = $c->service('order')->create_entity($shipment_id);

Return L<Markets::Domain::Enity::SalesOrder> object.

Creat and cache entity.getting method is L</get_entity>.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
