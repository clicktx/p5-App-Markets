package Yetie::Schema::ResultSet::Sales;
use Mojo::Base 'Yetie::Schema::ResultSet';

my $prefetch = [
    'customer',
    {
        billing_address => [ 'country', 'state' ],
    },
    {
        sales_orders => [
            {
                shipping_address => [ 'country', 'state' ],
            },
            'items',
        ],
    },
];

sub create_order {
    my ( $self, $order_data ) = @_;

    my $cb = sub { return $self->create($order_data) };
    return $self->schema->txn($cb);
}

sub get_id_by_order_id {
    my ( $self, $order_id ) = @_;

    my $result = $self->schema->resultset('SalesOrder')->find($order_id);
    return $result ? $result->sales_id : undef;
}

sub find_by_id {
    my ( $self, $id ) = @_;

    return $self->find(
        $id,
        {
            prefetch => $prefetch,
        },
    );
}

sub find_by_order_id {
    my ( $self, $order_id ) = @_;

    my $sales_id = $self->get_id_by_order_id($order_id);
    return $self->find_by_id($sales_id);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Sales

=head1 SYNOPSIS

    my $result = $schema->resultset('Sales')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Sales> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Sales> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<create_order>

    my $result = $rs->create_order($order_data);

=head2 C<get_id_by_order_id>

    my $sales_id = $rs->get_id_by_order_id($order_id);

=head2 C<find_by_id>

    my $order = $rs->find_by_id($sales_id);

=head2 C<find_by_order_id>

    my $order = $rs->find_by_order_id($order_id);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
