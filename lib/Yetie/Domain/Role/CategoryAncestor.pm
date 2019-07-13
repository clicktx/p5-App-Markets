package Yetie::Domain::Role::CategoryAncestor;
use Moose::Role;

has ancestors => (
    is      => 'ro',
    isa     => 'Yetie::Domain::List::CategoryTrees',
    default => sub { shift->factory('list-category_trees')->construct() }
);

1;
__END__

=head1 NAME

Yetie::Domain::Role::CategoryAncestor

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Role::CategoryAncestor> inherits all attributes from L<Moose::Role> and implements
the following new ones.

=head2 C<ancestors>

Return L<Yetie::Domain::List::CategoryTrees> object.

=head1 METHODS

L<Yetie::Domain::Role::CategoryAncestor> inherits all methods from L<Moose::Role> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Moose::Role>
