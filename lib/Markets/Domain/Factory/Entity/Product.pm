package Markets::Domain::Factory::Entity::Product;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # Aggregate categories
    my $categories = $self->param('categories');
    $self->aggregate( categories => 'entity-product-category', $categories || [] );

    # Aggregate ancestors
    my $ancestors = $self->param('ancestors');
    $self->aggregate( ancestors => 'entity-category', $ancestors || [] );
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Product

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Product->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-cart')->create(%args);

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
