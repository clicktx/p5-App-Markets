package Yetie::Domain::Factory::Entity::Category;
use Mojo::Base 'Yetie::Domain::Factory';

sub build {
    my ( $self, $category_id, $page, $rows ) = ( shift, shift, shift // 1, shift // 10 );

    my $category = $self->app->schema->resultset('Category')->find($category_id);
    return $self->app->factory('entity-category')->create( {} ) unless $category;

    my $data     = {
        id => $category->id,
        title => $category->title,
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
            page     => $page,
            rows     => $rows,
        },
    );
    $data->{products} = $products;
    return $self->app->factory('entity-category')->create($data);
}

sub _create_link {
    my ( $self, $category_id, $title ) = @_;
    return {
        title => $title,
        uri   => $self->app->url_for(
            'RN_category_name_base' => { category_name => $title, category_id => $category_id }
        )
    };
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Category

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Category->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-category')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Category> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Category> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head2 C<build>

    my $entity = $factory->build( $category_id, $page, $rows );

Return L<Yetie::Domain::Entity::Category> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
