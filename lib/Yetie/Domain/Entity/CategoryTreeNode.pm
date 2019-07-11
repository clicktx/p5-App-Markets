package Yetie::Domain::Entity::CategoryTreeNode;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with qw(Yetie::Domain::Role::Category Yetie::Domain::Role::CategoryTree);

has ancestors => ( is => 'ro', default => sub { shift->factory('list-category_trees')->construct() } );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTreeNode

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTreeNode> inherits all attributes from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::Category>, L<Yetie::Domain::Role::CategoryTree>,

and implements the following new ones.

=head2 C<ancestors>

    my $ancestors = $category_tree->ancestors;

Return L<Yetie::Domain::List::CategoryTrees> object.

=head2 C<children>

Inherits from L<Yetie::Domain::Role::CategoryTree>

    my $children = $category_tree->children;

Return L<Yetie::Domain::List::CategoryTrees> object.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTreeNode> inherits all methods from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::Category>, L<Yetie::Domain::Role::CategoryTree>,

and implements the following new ones.

=head2 C<has_child>

Inherits from L<Yetie::Domain::Role::CategoryTree>

    my $bool = $category_tree->has_child;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Category>, L<Yetie::Domain::Role::CategoryTree>, L<Yetie::Domain::Entity>
