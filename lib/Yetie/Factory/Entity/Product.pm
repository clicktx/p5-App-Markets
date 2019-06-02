package Yetie::Factory::Entity::Product;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # product_categories
    $self->aggregate( product_categories => 'list-product_categories', $self->param('product_categories') || [] );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Product

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Product->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-product')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Product> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Product> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
