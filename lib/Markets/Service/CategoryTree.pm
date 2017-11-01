package Markets::Service::CategoryTree;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Category') };

sub create_entity {
    my $self = shift;

    my @root_nodes = $self->resultset->search( { level => 0 } );
    my $branch_trees = $self->_create_branch_tree( \@root_nodes ) || [];
    my $category_tree = $self->app->factory('entity-category_tree')->create_entity( children => $branch_trees );

    # Store in cache
    $self->app->entity_cache( category_tree => $category_tree );
    return $category_tree;
}

sub get_entity {
    my $self  = shift;

    my $cache = $self->app->entity_cache('category_tree');
    return $cache if $cache;

    # Store in cache
    my $entity = $self->app->factory('category_tree')->build;
    $self->app->entity_cache( category_tree => $entity );
    return $entity;
}

sub _create_branch_tree {
    my $self  = shift;
    my $nodes = shift;

    my @tree;
    foreach my $node ( @{$nodes} ) {
        my $data = { id => $node->id, title => $node->title };
        if ( my @children = $node->children ) {
            $data->{children} = $self->_create_branch_tree( \@children );
        }
        my $entity = $self->app->factory('entity-category_tree-node')->create_entity($data);
        push @tree, $entity;
    }
    return \@tree;
}

1;
__END__

=head1 NAME

Markets::Service::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::CategoryTree> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::CategoryTree> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $category_tree = $c->service('category_tree')->create_entity();

Return L<Markets::Domain::Enity::CategoryTree> object.

Creat and cache entity.getting method is L</get_entity>.

=head2 C<get_entity>

    my $category_tree = $c->service('category_tree')->get_entity();

Return L<Markets::Domain::Enity::CategoryTree> object.

If there is a cache it returns it.
If it is not cached, it creates an entity object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
