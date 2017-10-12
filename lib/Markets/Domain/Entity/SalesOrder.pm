package Markets::Domain::Entity::SalesOrder;
use Markets::Domain::Entity;

# has id => sub {
#     my $self  = shift;
#     my $bytes = $self->order_id;
#     $self->hash_code($bytes);
# };
# has 'id';
has [qw/order_number customer_id billing_address created_at updated_at/];
has shipments => sub { Markets::Domain::Collection->new };

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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
