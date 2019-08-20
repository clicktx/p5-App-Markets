package Yetie::Factory::Entity::ProductCategory;
use Mojo::Base 'Yetie::Factory';

1;
__END__

=head1 NAME

Yetie::Factory::Entity::ProductCategory

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::ProductCategory->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-product_category')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::ProductCategory> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::ProductCategory> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
