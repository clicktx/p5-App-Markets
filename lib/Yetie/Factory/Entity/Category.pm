package Yetie::Factory::Entity::Category;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # products
    $self->aggregate( products => 'list-products' );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::Category

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::Category->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-category')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::Category> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::Category> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
