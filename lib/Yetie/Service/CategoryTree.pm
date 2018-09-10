package Yetie::Service::CategoryTree;
use Mojo::Base 'Yetie::Service';

sub get_cache { shift->app->cache('category_tree') }

sub search_all {
    my $self = shift;
    return $self->get_cache if $self->get_cache;

    my $root = $self->resultset('Category')->search( { level => 0 } );
    my $tree = _create_tree($root) || [];
    my $entity = $self->app->factory('entity-category_tree')->create( children => $tree );
    $self->app->cache( category_tree => $entity );
    return $entity;
}

sub _create_tree {
    my $nodes = shift;
    my @tree;
    $nodes->each( sub { push @tree, shift->to_data } );
    return \@tree;
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

=head2 C<get_cache>

    my $category_tree = $c->get_cache;

Return L<Yetie::Domain::Enity::CategoryTree> object || undef.

=head2 C<search_all>

    my $category_tree = $c->service('category_tree')->search_all;

Return L<Yetie::Domain::Enity::CategoryTree> object.

If there is a cache it returns it.
If it is not cached, it creates an entity object.

See L</get_cache>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
