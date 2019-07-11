package Yetie::Domain::Role::CategoryTree;
use Moose::Role;

has children => (
    is      => 'ro',
    isa     => 'Yetie::Domain::List::CategoryTrees',
    default => sub { shift->factory('list-category_trees')->construct() },
);

sub has_child { shift->children->count ? 1 : 0 }

1;
__END__

=head1 NAME

Yetie::Domain::Role::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Role::CategoryTree> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head2 C<children>

Return L<Yetie::Domain::List::CategoryTrees> object.

=head1 METHODS

L<Yetie::Domain::Role::CategoryTree> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head2 C<has_child>

    my $bool = $category_tree->has_child;

Return boolean value.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
