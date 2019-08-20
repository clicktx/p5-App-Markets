package Yetie::Service::Category;
use Mojo::Base 'Yetie::Service';

sub find_category_with_products { return shift->_find_category( @_, 1 ) }

sub find_category {
    my ($category) = shift->_find_category( @_, undef );
    return $category;
}

sub get_category_tree {
    my $self = shift;

    my $cache = $self->app->cache('category_tree');
    return $cache if $cache;

    # Create tree entities
    my $root = $self->resultset('Category')->search( { level => 0 } );
    my $tree = $self->app->factory('entity-category_tree_root')->construct( children => $root->to_data );

    # Set to cache
    $self->app->cache( category_tree => $tree );
    return $tree;
}

sub _find_category {
    my ( $self, $category_id, $form, $with_products ) = @_;

    my $result = $self->resultset('Category')->find($category_id);
    my $data = $result ? $result->to_data( { no_children => 1 } ) : {};
    return ( $self->factory('entity-category')->construct($data), {} ) if !$result || !$with_products;

    # with products
    my $products_rs = _get_products( $result, $form );
    $data->{products} = $products_rs->to_data(
        {
            no_datetime => 1,
            no_relation => 1,
        }
    );
    my $category    = $self->factory('entity-category')->construct($data);
    my $pager       = $products_rs ? $products_rs->pager : undef;
    my $breadcrumbs = $self->service('breadcrumb')->get_list_by_category_id($category_id);

    return ( $category, $pager, $breadcrumbs );
}

sub _get_products {
    my ( $category, $form ) = @_;

    # TODO: デバッグ用なので削除する
    my $page_no  = $form->param('page')     || 1;
    my $per_page = $form->param('per_page') || 3;

    return $category->search_products_in_categories( { page => $page_no, rows => $per_page } );
}

1;
__END__

=head1 NAME

Yetie::Service::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Service::Category> inherits all attributes from L<Yetie::Service> and implements
the following new ones.

=head1 METHODS

L<Yetie::Service::Category> inherits all methods from L<Yetie::Service> and implements
the following new ones.

=head2 C<find_category_with_products>

    my ( $entity, $pager, $breadcrumbs ) = $service->find_category_with_products( $category_id, $form );

Return  L<Yetie::Domain::Entity::Category> object,

        L<DBIx::Class::ResultSet::Pager> object,

        L<Yetie::Domain::List::Breadcrumbs> object,

The attribute "products" has a list of products.

=head2 C<find_category>

    my $entity = $service->find_category( $category_id, $form );

Return L<Yetie::Domain::Entity::Category> object.

=head2 C<get_category_tree>

    my $category_tree = $service->get_category_tree;

Return L<Yetie::Domain::Enity::CategoryTree> object.

If there is a cache it returns it.
If it is not cached, it creates an entity object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Service>
