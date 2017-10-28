package Markets::Service::Order;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Sales::OrderHeader') };

1;
__END__

=head1 NAME

Markets::Service::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Order> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Order> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $category_tree = $c->service('order')->create_entity($shipment_id);

Return L<Markets::Domain::Enity::SalesOrder> object.

Creat and cache entity.getting method is L</get_entity>.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
