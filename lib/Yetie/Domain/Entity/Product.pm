package Yetie::Domain::Entity::Product;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity::Page';

has title       => ( is => 'ro', default => '' );
has description => ( is => 'ro', default => '' );
has price       => ( is => 'ro', default => 0 );
has created_at  => ( is => 'ro' );
has updated_at  => ( is => 'ro' );
has product_categories => (
    is      => 'ro',
    lazy    => 1,
    default => sub { __PACKAGE__->factory('list-product_categories')->construct() }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Product> inherits all attributes from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head2 C<title>

=head2 C<description>

=head2 C<price>

=head2 C<product_categories>

Return L<Yetie::Domain::List::ProductCategories> object.

=head2 C<created_at>

Return L<DateTime> object or C<undef>.

=head2 C<updated_at>

Return L<DateTime> object or C<undef>.

=head1 METHODS

L<Yetie::Domain::Entity::Product> inherits all methods from L<Yetie::Domain::Entity::Page> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Page>, L<Yetie::Domain::Entity>
