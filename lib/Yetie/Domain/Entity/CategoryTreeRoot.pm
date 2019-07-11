package Yetie::Domain::Entity::CategoryTreeRoot;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

with qw(Yetie::Domain::Role::CategoryTree);

has _index => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
    writer  => 'set_index',
);

sub get_node {
    my ( $self, $id ) = @_;
    return $self->_index->{$id};
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::CategoryTreeRoot

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::CategoryTreeRoot> inherits all attributes from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::CategoryTree>

and implements the following new ones.

=head2 C<children>

Inherits from L<Yetie::Domain::Role::CategoryTree>

    my $children = $category_root->children;

Return L<Yetie::Domain::List::CategoryTrees> object.

=head1 METHODS

L<Yetie::Domain::Entity::CategoryTreeRoot> inherits all methods from L<Yetie::Domain::Entity>
and L<Yetie::Domain::Role::CategoryTree>

and implements the following new ones.

=head2 C<get_node>

    my $node = $categoty_root->get_node($category_id);

Return L<Yetie::Domain::Entity::CategoryTreeNode> object.

=head2 C<has_child>

Inherits from L<Yetie::Domain::Role::CategoryTree>

    my $bool = $category_root->has_child;

Return boolean value.

=head2 C<set_index>

    my %category_index = ( 1 => Yetie::Domain::Entity::CategoryTreeNode->new, ... );
    $category_root->set_index(\%category_index);

Set to attribute C<_index>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Role::Category>, L<Yetie::Domain::Role::CategoryTree>, L<Yetie::Domain::Entity>
