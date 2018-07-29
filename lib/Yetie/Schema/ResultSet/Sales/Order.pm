package Yetie::Schema::ResultSet::Sales::Order;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

my $prefetch = [
    'shipping_address',
    'items',
    {
        sales => [ 'customer', 'billing_address' ],
    },
];

sub find_by_id {
    my ( $self, $shipment_id ) = @_;

    return $self->find(
        $shipment_id,
        {
            prefetch => $prefetch,
        },
    );
}

sub search_sales_orders {
    my ( $self, $args ) = @_;

    my $where = $args->{where} || {};
    my $order_by = $args->{order_by} || { -desc => 'me.id' };
    my $page = $args->{page_no};
    my $rows = $args->{per_page};

    return $self->search(
        $where,
        {
            page     => $page,
            rows     => $rows,
            order_by => $order_by,
            prefetch => $prefetch,
        }
    );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Sales::Order

=head1 SYNOPSIS

    my $result = $schema->resultset('Sales::Order')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Sales::Order> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Sales::Order> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_by_id>

    my $shipment = $rs->find_by_id($shipment_id);

=head2 C<search_sales_orders>

    my $orders = $rs->search_sales_orders( \%args);

    my $orders = $rs->search_sales_orders(
        {
            where => { ... },
            order_by => { ... },
            page_no => 5,
            $rows => 20,
        }
    );

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
