package Yetie::Service::Order;
use Mojo::Base 'Yetie::Service';

has resultset => sub { shift->schema->resultset('Sales::Order') };

1;
__END__

=head1 NAME

Yetie::Service::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Order> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Order> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
