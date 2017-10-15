package Markets::Domain::Entity::SalesOrder;
use Markets::Domain::Entity;
use Markets::Domain::Collection;
use Markets::Domain::Entity::Customer;
use Markets::Domain::Entity::Address;

has billing_address => sub { Markets::Domain::Entity::Address->new };
has created_at      => undef;
has customer        => sub { Markets::Domain::Entity::Customer->new };
has shipments       => sub { Markets::Domain::Collection->new };
has updated_at      => undef;

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

=head2 C<billing_address>

Return L<Markets::Domain::Entity::Address> object.

=head2 C<created_at>

Return L<DateTime> object or undef.

=head2 C<customer>

Return L<Markets::Domain::Entity::Customer> object.

=head2 C<shipments>

Return L<Markets::Domain::Collection> object.
Elements is L<Markets::Domain::Entity::Shipment> object.

=head2 C<updated_at>

Return L<DateTime> object or undef.

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
