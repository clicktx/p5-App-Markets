package Yetie::Domain::Entity::CategoryTree::Node;
use Yetie::Domain::Entity;

has 'children';
has level   => 0;
has root_id => 0;
has title   => '';

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTree::Node

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTree::Node> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<children>

Return L<Yetie::Domain::Collection> object or C<undefined>.

=head2 C<level>

=head2 C<root_id>

=head2 C<title>

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTree::Node> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
