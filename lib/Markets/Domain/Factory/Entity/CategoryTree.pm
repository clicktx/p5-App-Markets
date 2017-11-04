package Markets::Domain::Factory::Entity::CategoryTree;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub build {
    my $self = shift;

    my @root_nodes = $self->app->schema->resultset('Category')->search( { level => 0 } );
    my $branch_trees = $self->_create_branch_tree( \@root_nodes ) || [];
    return $self->app->factory('entity-category_tree')->create_entity( children => $branch_trees );
}

sub cook {
    my $self = shift;

    # children
    $self->param( children => collection( @{ $self->param('children') } ) );
}

sub _create_branch_tree {
    my ( $self, $nodes ) = ( shift, shift // [] );

    my @tree;
    foreach my $node ( @{$nodes} ) {
        my $data = { id => $node->id, title => $node->title };
        if ( my @children = $node->children ) {
            $data->{children} = $self->_create_branch_tree( \@children );
        }
        push @tree, $self->app->factory('entity-category_tree-node')->create_entity($data);
    }
    return \@tree;
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::CategoryTree

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::CategoryTree->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category_tree')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::CategoryTree> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::CategoryTree> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head2 C<build>

    my $entity = $factory->build();

Return L<Markets::Domain::Entity::CategoryTree> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
