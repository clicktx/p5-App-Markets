package Yetie::Service::Order;
use Mojo::Base 'Yetie::Service';
use Yetie::Util qw(args2hash);

sub find_order {
    my ( $self, $order_id ) = @_;

    my $result = $self->resultset('SalesOrder')->find_by_id($order_id);
    my $data = $result ? $result->to_data : {};
    return $self->factory('entity-order_detail')->construct($data);
}

sub search_orders {
    my ( $self, %args ) = ( shift, args2hash(@_) );

    my $conditions = {
        where    => $args{where},
        order_by => $args{order_by},
        page_no  => $args{page_no} || 1,
        per_page => $args{per_page},
    };
    my $rs = $self->resultset('SalesOrder')->search_sales_orders($conditions);
    my $orders = $self->factory('list-order_details')->construct( list => $rs->to_data );
    return ( $orders, $rs->pager );
}

sub store_items {
    my ( $self, $order, $param_list ) = @_;

    my $order_id = $order->id;
    $order->items->each(
        sub {
            my ( $item, $num ) = @_;
            my $params = $param_list->[$num];
            $item->set_attributes($params);

            my $data = $item->to_order_data;
            $data->{order_id} = $order_id;
            if ( $item->is_modified ) { $self->resultset('SalesOrderItem')->store_item($data) }
        }
    );
    return;
}

1;
__END__

=head1 NAME

Yetie::Service::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Order> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Order> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<find_order>

    my $order_detail = $servece->find_order($order_id);

Return L<Yetie::Domain::Entity::OrderDetail> object.

=head2 C<search_orders>

    my $entity = $service->search_orders(%conditions);

=head2 C<store_items>

    $service->store_items( $order, \@param_list );

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
