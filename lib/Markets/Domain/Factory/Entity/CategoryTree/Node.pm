package Markets::Domain::Factory::Entity::CategoryTree::Node;
use Mojo::Base 'Markets::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate children
    my $children = $self->param('children');
    if ( ref $children eq 'ARRAY' ) {
        $self->aggregate( children => 'entity-category_tree-node', $children );
    }
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::CategoryTree::Node

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::CategoryTree::Node->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category_tree-node')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::CategoryTree::Node> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::CategoryTree::Node> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
