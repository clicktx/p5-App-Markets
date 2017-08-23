package Markets::Service::Product;
use Mojo::Base 'Markets::Service';

sub create_entity {
    my ( $self, $product_id ) = @_;

    # Sort primary category is first
    # my $columns = [
    #     qw(me.id me.title me.description me.price me.created_at me.updated_at),
    #     qw(product_categories.product_id product_categories.category_id product_categories.is_primary),
    #     qw(detail.id detail.root_id detail.lft detail.rgt detail.level detail.title),
    # ];
    my $columns = [
        qw(me.id me.title me.description me.price me.created_at me.updated_at),
        qw(product_categories.category_id product_categories.is_primary),
        qw(detail.root_id detail.level detail.title),
    ];
    my $data = $self->schema->resultset('Product')->search(
        { 'me.id' => $product_id },
        {
            colmuns  => $columns,
            order_by => { -desc => 'is_primary' },
            prefetch => { product_categories => 'detail' },
        }
    )->hashref_first;

    # Ancestors(Primary category path)
    my $primary_category = $data->{product_categories}->[0];
    my $ancestors        = [];
    if ($primary_category) {
        $ancestors = $self->schema->resultset('Category')->get_ancestors_arrayref( $primary_category->{category_id} );
        push @{$ancestors}, $primary_category->{detail};
    }
    $data->{ancestors} = $ancestors;

    return $self->app->factory('entity-product')->create($data);
}

1;
__END__

=head1 NAME

Markets::Service::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Service::Product> inherits all attributes from L<Markets::Service> and implements
the following new ones.

=head1 METHODS

L<Markets::Service::Product> inherits all methods from L<Markets::Service> and implements
the following new ones.

=head2 C<create_entity>

    my $product = $app->service('product')->create_entity($product_id);

Return L<Markets::Domain::Entity::Product> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Service>
