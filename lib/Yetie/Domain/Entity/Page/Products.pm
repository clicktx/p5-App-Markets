package Yetie::Domain::Entity::Page::Products;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity::Page';

has product_list => (
    is      => 'ro',
    default => sub { __PACKAGE__->factory('list-products')->construct() }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Page::Products

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Page::Products> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<product_list>

    my $collection = $products->product_list;

Return L<Yetie::Domain::List::Products> object.

=head1 METHODS

L<Yetie::Domain::Entity::Page::Products> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
