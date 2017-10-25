package Markets::Service::Category;
use Mojo::Base 'Markets::Service';

has resultset => sub { shift->schema->resultset('Category') };

sub create_entity {
    my ( $self, $category_id, $page, $rows ) = ( shift, shift, shift // 1, shift // 10 );

    my $data     = {};
    my $category = $self->resultset->find($category_id);
    return unless $category;

    $data->{title} = $category->title;

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
    my $products     = $self->schema->resultset('Product')->search(
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

sub get_category_choices { shift->resultset->get_category_choices(@_) }

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

Markets::Service::Category

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Category> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Category> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $category = $c->service('category')->create_entity( $category_id, $page, $rows );

Return L<Markets::Domain::Entity::Category> object or C<undefined>.

=head2 C<get_category_choices>

    my $choices = $service->get_category_choices(\@category_ids);

See L<Markets::Schema::ResultSet::Category/get_category_choices>

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
