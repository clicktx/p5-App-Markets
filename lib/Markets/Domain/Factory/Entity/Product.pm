package Markets::Domain::Factory::Entity::Product;
use Mojo::Base 'Markets::Domain::Factory';

sub build {
    my ( $self, $product_id ) = @_;

    my $schema  = $self->app->schema;
    my $columns = [
        qw(
          id
          title
          description
          price
          created_at
          updated_at
          )
    ];
    my $itr = $schema->resultset('Product')->search( { id => $product_id }, { columns => $columns } );
    my $data = $itr->hashref_first || {};

    # Categories
    my $product_categories = $schema->resultset('Product::Category')->get_product_categories_arrayref($product_id);
    $data->{product_categories} = $product_categories;

    # Ancestors(Primary category path)
    my @primary_category;
    my $primary_category = $data->{product_categories}->[0];

    if ($primary_category) {
        my $ancestors =
          $schema->resultset('Category')->get_ancestors_arrayref( $primary_category->{category_id} );
        push @primary_category, @{$ancestors};

        # Current category
        my %primary;
        $primary{id}    = $primary_category->{category_id};
        $primary{title} = $primary_category->{title};
        push @primary_category, \%primary;
    }
    $data->{primary_category} = \@primary_category;

    return $self->create($data);
}

sub cook {
    my $self = shift;

    # Aggregate product_categories
    my $product_categories = $self->param('product_categories');
    $self->aggregate( product_categories => 'entity-product-category', $product_categories || [] );

    # Aggregate primary_category
    my $primary_category = $self->param('primary_category');
    $self->aggregate( primary_category => 'entity-category_tree-node', $primary_category || [] );
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Product

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Product->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-product')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Product> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::Product> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head2 C<build>

    my $entity = $factory->build( $product_id );

Return L<Markets::Domain::Entity::Product> object.

Create entity by product ID.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
