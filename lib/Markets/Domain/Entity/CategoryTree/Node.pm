package Markets::Domain::Entity::CategoryTree::Node;
use Markets::Domain::Entity;

has 'children';
has level   => 0;
has root_id => 0;
has title   => '';

1;
__END__

=head1 NAME

Markets::Domain::Entity::CategoryTree::Node

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::CategoryTree::Node> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<children>

Return L<Markets::Domain::Collection> object or C<undefined>.

=head2 C<level>

=head2 C<root_id>

=head2 C<title>

=head1 METHODS

L<Markets::Domain::Entity::CategoryTree::Node> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
