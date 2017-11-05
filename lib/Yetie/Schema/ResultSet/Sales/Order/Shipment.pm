package Yetie::Schema::ResultSet::Sales::Order::Shipment;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

sub find_by_id {
    my ( $self, $shipment_id ) = @_;

    return $self->find(
        $shipment_id,
        {
            prefetch => [
                'shipping_address',
                'shipping_items',
                {
                    order_header => [ 'customer', 'billing_address' ],
                },
            ],
        },
    );
}

sub search_sales_list {
    my ( $self, $args ) = @_;

    my $where = $args->{where} || {};
    my $order_by = $args->{order_by} || { -desc => 'me.id' };
    my $page_no = $args->{page_no};
    my $rows    = $args->{rows};

    return $self->search(
        $where,
        {
            page     => $page_no,
            rows     => $rows,
            order_by => $order_by,
            prefetch => [ 'shipping_address', { order_header => [ 'customer', 'billing_address' ] }, ],
        }
    );
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Sales::Order::Shipment

=head1 SYNOPSIS

    my $data = $schema->resultset('Sales::Order::Shipment')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Sales::Order::Shipment> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Sales::Order::Shipment> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_by_id>

    my $shipment = $rs->find_by_id($shipment_id);

=head2 C<search_sales_list>

    my $orders = $rs->search_sales_list( \%args);

    my $orders = $rs->search_sales_list(
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
