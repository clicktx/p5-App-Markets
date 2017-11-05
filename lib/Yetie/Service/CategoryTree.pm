package Yetie::Service::CategoryTree;
use Mojo::Base 'Yetie::Service';

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

Yetie::Service::CategoryTree

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::CategoryTree> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::CategoryTree> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<get_entity>

    my $category_tree = $c->service('category_tree')->get_entity();

Return L<Yetie::Domain::Enity::CategoryTree> object.

If there is a cache it returns it.
If it is not cached, it creates an entity object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
