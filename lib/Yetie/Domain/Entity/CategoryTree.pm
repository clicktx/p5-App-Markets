package Yetie::Domain::Entity::CategoryTree;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::MooseEntity';

has level    => ( is => 'ro', default => 0 );
has root_id  => ( is => 'ro', default => 0 );
has title    => ( is => 'ro', default => q{} );
has children => ( is => 'ro', default => sub { __PACKAGE__->factory('list-category_trees')->construct() } );

sub has_child { shift->children->count ? 1 : 0 }

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTree> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<level>

=head2 C<root_id>

=head2 C<title>

=head2 C<children>

Return L<Yetie::Domain::List::CategoryTrees> object.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTree> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<has_child>

    my $bool = $category_tree->has_child;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
