package Yetie::Domain::Entity::Page::Customers;
use Yetie::Domain::Base 'Yetie::Domain::Entity::Page';

has customer_list => sub { __PACKAGE__->factory('list-customers')->construct() };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page::Customers

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page::Customers> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<customer_list>

    my $collection = $entity->customer_list;

Return L<Yetie::Domain::List::Customers> object.

=head1 METHODS

L<Yetie::Domain::Entity::Page::Customers> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
