package Markets::Service::Address;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Address') };

1;
__END__

=head1 NAME

Markets::Service::Address

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Address> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Address> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
