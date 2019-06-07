package Yetie::Service::Order;
use Mojo::Base 'Yetie::Service';

sub find_order {
    my ( $self, $order_id ) = @_;

    my $result = $self->resultset('Sales::Order')->find_by_id($order_id);
    my $data = $result ? $result->to_data : {};
    return $self->factory('entity-order_detail')->construct($data);
}

sub search_orders {
    my ( $self, $form ) = @_;

    my $conditions = {
        where    => '',
        order_by => '',
        page_no  => $form->param('page') || 1,
        per_page => $form->param('per_page') || 5,
    };
    my $rs = $self->resultset('Sales::Order')->search_sales_orders($conditions);
    my $orders = $self->factory('list-order_details')->construct( list => $rs->to_data );
    return ( $orders, $rs->pager );
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

    my $entity = $service->search_orders($form);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
