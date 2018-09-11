package Yetie::Domain::Factory::Entity::Shipment;
use Mojo::Base 'Yetie::Domain::Factory';
use Yetie::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # items
    my @items;
    foreach my $item ( @{ $self->{items} } ) {
        push @items, $self->factory('entity-cart-item')->construct($item);
    }
    $self->param( items => collection(@items) );

    # shipping_address
    $self->aggregate( shipping_address => 'entity-address', $self->{shipping_address} || {} );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Shipment

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Shipment->new( %args )->construct();

    # In controller
    my $entity = $c->factory('entity-shipment')->construct(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Shipment> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Shipment> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
