package Markets::Service::CategoryTree;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Category') };

sub create_entity {
    my $self = shift;

    my @root_nodes = $self->resultset->search( { level => 0 } );
    my $branch_trees = $self->_create_branch_tree( \@root_nodes ) || [];
    return $self->app->factory('entity-category_tree')->create_entity( children => $branch_trees );
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
        my $entity = $self->app->factory('entity-category')->create_entity($data);
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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
