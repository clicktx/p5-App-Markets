package Yetie::Factory::Entity::Page::Category;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate products
    my $products = $self->param('products');
    $self->aggregate_collection( products => 'entity-page-product', $products || [] );

    # breadcrumbs
    $self->aggregate( breadcrumbs => 'list-breadcrumbs', $self->param('breadcrumbs') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Page::Category

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Page::Category->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-page-category')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Page::Category> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Page::Category> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
