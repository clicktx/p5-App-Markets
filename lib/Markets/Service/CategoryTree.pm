package Markets::Service::CategoryTree;
use Mojo::Base 'Markets::Service';

sub get_entity {
    my $self = shift;

    my $cache = $self->app->entity_cache('category_tree');
    return $cache if $cache;

    # Store in cache
    my $entity = $self->app->factory('category_tree')->build;
    $self->app->entity_cache( category_tree => $entity );
    return $entity;
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

=head2 C<get_entity>

    my $category_tree = $c->service('category_tree')->get_entity();

Return L<Markets::Domain::Enity::CategoryTree> object.

If there is a cache it returns it.
If it is not cached, it creates an entity object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
