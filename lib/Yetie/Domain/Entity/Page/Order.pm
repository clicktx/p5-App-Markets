package Yetie::Domain::Entity::Page::Order;
use Yetie::Domain::Base 'Yetie::Domain::Entity::Page';

has detail => sub { __PACKAGE__->factory('entity-order') };

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page::Order

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page::Order> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Entity::Page::Order> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>, L<Yetie::Domain::Entity::Page>
