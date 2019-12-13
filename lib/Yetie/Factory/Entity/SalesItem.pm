package Yetie::Factory::Entity::SalesItem;
use Mojo::Base 'Yetie::Factory::Entity::CartItem';

1;
__END__

=head1 NAME

Yetie::Factory::Entity::SalesItem

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::SalesItem->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-sales_item')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::SalesItem> inherits all attributes from L<Yetie::Factory::Entity::CartItem> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::SalesItem> inherits all methods from L<Yetie::Factory::Entity::CartItem> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory::Entity::CartItem>
