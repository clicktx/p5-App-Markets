package Markets::Domain::Entity::Order;
use Markets::Domain::Entity;

# has id => sub {
#     my $self  = shift;
#     my $bytes = $self->order_id;
#     $self->hash_code($bytes);
# };
has 'id';
has [qw/order_number customer_id billing_address created_at/];
has [qw/line_items/];
has 'shipments';

1;
__END__

=head1 NAME

Markets::Domain::Entity::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Order> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Entity::Order> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
