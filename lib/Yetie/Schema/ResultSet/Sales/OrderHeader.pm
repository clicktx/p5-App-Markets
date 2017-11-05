package Yetie::Schema::ResultSet::Sales::OrderHeader;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

sub get_id_by_shipment_id {
    my ( $self, $shipment_id ) = @_;

    my $result = $self->result_source->schema->resultset('Sales::Order::Shipment')->find($shipment_id);
    return $result ? $result->order_header_id : undef;
}

sub find_by_id {
    my ( $self, $id ) = @_;

    return $self->find(
        $id,
        {
            prefetch => [
                'customer',
                'billing_address',
                {
                    shipments => [ 'shipping_address', 'shipping_items' ],
                },
            ],
        },
    );
}

sub find_by_shipment_id {
    my ( $self, $shipment_id ) = @_;

    my $order_header_id = $self->get_id_by_shipment_id($shipment_id);
    return $self->find_by_id($order_header_id);
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Sales::OrderHeader

=head1 SYNOPSIS

    my $data = $schema->resultset('Sales::OrderHeader')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Sales::OrderHeader> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Sales::OrderHeader> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<get_id_by_shipment_id>

    my $order_header_id = $rs->get_id_by_shipment_id($shipment_id);

=head2 C<find_by_id>

    my $order = $rs->find_by_id($order_header_id);

=head2 C<find_by_shipment_id>

    my $order = $rs->find_by_shipment_id($shipment_id);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
