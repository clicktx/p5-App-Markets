package Yetie::Factory::Entity::Page::Product;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate product_categories
    my $product_categories = $self->param('product_categories');
    $self->aggregate_collection( product_categories => 'entity-product_category', $product_categories || [] );

    # breadcrumbs
    $self->aggregate( breadcrumbs => 'list-breadcrumbs', $self->param('breadcrumbs') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Page::Product

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Page::Product->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-page-product')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Page::Product> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Page::Product> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
