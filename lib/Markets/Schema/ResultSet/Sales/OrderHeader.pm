package Markets::Schema::ResultSet::Sales::OrderHeader;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub find_by_id {
    my ( $self, $order_header_id ) = @_;

    return $self->find(
        $order_header_id,
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

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Sales::OrderHeader

=head1 SYNOPSIS

    my $data = $schema->resultset('Sales::OrderHeader')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::ResultSet::Sales::OrderHeader> inherits all attributes from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::ResultSet::Sales::OrderHeader> inherits all methods from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<find_by_id>

    my $order = $rs->find_by_id($order_header_id);

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
