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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
