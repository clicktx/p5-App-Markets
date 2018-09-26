package Yetie::Factory::Entity::Page::Products;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    my $product_list = $self->param('product_list');
    $self->aggregate_collection( product_list => 'entity-page-product', $product_list || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Page::Products

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Page::Products->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-page-products')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Page::Products> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Page::Products> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Factory>
