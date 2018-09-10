package Yetie::Domain::Factory::Entity::Page::Product;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # Aggregate product_categories
    my $product_categories = $self->param('product_categories');
    $self->aggregate_collection( product_categories => 'entity-product-category', $product_categories || [] );

    # Aggregate breadcrumbs
    my $breadcrumbs = $self->param('breadcrumbs');
    $self->aggregate_collection( breadcrumbs => 'entity-breadcrumb', $breadcrumbs || [] );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Page::Product

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Page::Product->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-page-product')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Page::Product> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Page::Product> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
