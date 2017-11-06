package Yetie::Domain::Factory::Entity::Product;
use Mojo::Base 'Yetie::Domain::Factory';

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

    # Breadcrumb
    my $primary_category = $data->{product_categories}->[0];
    my @breadcrumb;
    my $result = $schema->resultset('Category')->find( $primary_category->{category_id} );
    $result->ancestors->each(
        sub {
            my $category = shift;
            push @breadcrumb, $self->_create_link( $category->id, $category->title );
        }
    ) if $result;
    push @breadcrumb, $self->_create_link( $primary_category->{category_id}, $primary_category->{title} );
    $data->{breadcrumb} = \@breadcrumb;

    return $self->create($data);
}

sub cook {
    my $self = shift;

    # Aggregate product_categories
    my $product_categories = $self->param('product_categories');
    $self->aggregate( product_categories => 'entity-product-category', $product_categories || [] );

    # Aggregate breadcrumb
    $self->aggregate( breadcrumb => 'entity-link', $self->param('breadcrumb') || [] );
}

sub _create_link {
    my ( $self, $category_id, $title ) = @_;
    return {
        title => $title,
        url   => $self->app->url_for(
            'RN_category' => { category_name => $title, category_id => $category_id }
        )
    };
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Product

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Product->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-product')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Product> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Product> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head2 C<build>

    my $entity = $factory->build( $product_id );

Return L<Yetie::Domain::Entity::Product> object.

Create entity by product ID.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
