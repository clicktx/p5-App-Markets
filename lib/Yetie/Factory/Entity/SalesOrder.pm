package Yetie::Factory::Entity::SalesOrder;
use Mojo::Base 'Yetie::Factory';

sub cook {
    my $self = shift;

    # Aggregate items
    $self->aggregate( items => 'list-sales_items' );

    # shipping_address
    $self->aggregate( shipping_address => 'entity-address' );

    # Aggregate shippings
    $self->aggregate( shipments => 'list-shipments' );
}

1;
__END__

=head1 NAME

Yetie::Factory::Entity::SalesOrder

=head1 SYNOPSIS

    my $entity = Yetie::Factory::Entity::SalesOrder->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-sales_order')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Factory::Entity::SalesOrder> inherits all attributes from L<Yetie::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Factory::Entity::SalesOrder> inherits all methods from L<Yetie::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Factory>
