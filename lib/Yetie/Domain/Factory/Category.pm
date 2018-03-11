package Yetie::Domain::Factory::Category;
use Mojo::Base 'Yetie::Domain::Factory';

sub build {
    my ( $self, $category_id, $opt ) = ( shift, shift, shift // {} );

    my $category = $self->app->schema->resultset('Category')->find($category_id);
    return $self->app->factory('entity-category')->create( {} ) unless $category;

    my $parent_id = $category->parent ? $category->parent->id : undef;
    my $data = {
        id        => $category->id,
        parent_id => $parent_id,
        title     => $category->title,
    };

    # breadcrumb
    my @breadcrumb;
    my $itr = $category->ancestors;
    while ( my $ancestor = $itr->next ) {
        push @breadcrumb, $self->_create_link( $ancestor->id, $ancestor->title );
    }
    push @breadcrumb, $self->_create_link( $category_id, $category->title );
    $data->{breadcrumb} = \@breadcrumb;

    # products
    # 下位カテゴリに所属するproductsも全て取得
    # NOTE: SQLが非効率な可能性高い
    my @category_ids = $category->descendant_ids;
    my $products     = $self->app->schema->resultset('Product')->search(
        { 'product_categories.category_id' => { IN => \@category_ids } },
        {
            prefetch => 'product_categories',
            page     => $opt->{page} // 1,
            rows     => $opt->{rows} // 10,
        },
    );
    $data->{products} = $products;
    return $self->app->factory('entity-category')->create($data);
}

sub cook {
    my $self = shift;

    # Aggregate breadcrumbs
    my $breadcrumbs = $self->param('breadcrumbs');
    $self->aggregate_collection( breadcrumbs => 'entity-breadcrumb', $breadcrumbs || [] );
}

sub _create_link {
    my ( $self, $category_id, $title ) = @_;
    return {
        title => $title,
        url   => $self->app->url_for(
            'RN_category' => { category_name => $title, category_id => $category_id }
        )->to_string
    };
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Category

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Category->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Category> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Category> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head2 C<build>

    my $entity = $factory->build( $category_id, { page => $page, rows => $rows} );

Return L<Yetie::Domain::Entity::Category> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
