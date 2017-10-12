package Markets::Domain::Entity::SalesOrder;
use Markets::Domain::Entity;

has [qw/order_number customer_id billing_address created_at updated_at/];
has shipments => sub { Markets::Domain::Collection->new };

sub is_multiple_shipment { return @{ shift->shipments } > 1 ? 1 : 0 }

1;
__END__

=head1 NAME

Markets::Domain::Entity::SalesOrder

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::SalesOrder> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Entity::SalesOrder> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<is_multiple_shipment>

    my $bool = $entity->is_multiple_shipment;

Return boolean value.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
