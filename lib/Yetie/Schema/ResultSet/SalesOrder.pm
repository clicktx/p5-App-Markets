package Yetie::Schema::ResultSet::SalesOrder;
use Mojo::Base 'Yetie::Schema::ResultSet';

my $prefetch = [
    'shipping_address',
    {
        items => [ { sales_price => 'price' }, 'tax_rule' ],
    },
    {
        sales => [ 'customer', 'billing_address' ],
    },
];

sub find_by_id {
    my ( $self, $id ) = @_;

    return $self->search(
        {
            'me.id'    => $id,
            trashed_at => \'IS NULL',
        },
        {
            prefetch => $prefetch,
        },
    )->first;
}

sub search_sales_orders {
    my ( $self, $args ) = @_;

    my $where = $args->{where} || {};
    $where->{trashed_at} = \'IS NULL';

    my $order_by = $args->{order_by} || { -desc => 'me.id' };
    my $page     = $args->{page_no};
    my $rows     = $args->{per_page};

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

Yetie::Schema::ResultSet::SalesOrder

=head1 SYNOPSIS

    my $result = $schema->resultset('SalesOrder')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::SalesOrder> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::SalesOrder> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_by_id>

    my $sales_order = $rs->find_by_id($sales_order_id);

=head2 C<search_sales_orders>

    my $orders = $rs->search_sales_orders( \%args );

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

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
