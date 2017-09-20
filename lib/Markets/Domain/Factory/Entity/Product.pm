package Markets::Domain::Factory::Entity::Product;
use Mojo::Base 'Markets::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate product_categories
    my $product_categories = $self->param('product_categories');
    $self->aggregate( product_categories => 'entity-product-category', $product_categories || [] );

    # Aggregate primary_category
    my $primary_category = $self->param('primary_category');
    $self->aggregate( primary_category => 'entity-category', $primary_category || [] );
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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
