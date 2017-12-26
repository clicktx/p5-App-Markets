package Yetie::Domain::Factory::Shipment;
use Mojo::Base 'Yetie::Domain::Factory';
use Yetie::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # items
    my @items;
    foreach my $item ( @{ $self->{items} } ) {
        push @items, $self->factory('entity-cart-item')->create($item);
    }
    $self->param( items => collection(@items) );

    # shipping_address
    my $shipping_address = $self->factory('entity-address')->create( $self->{shipping_address} || {} );
    $self->param( shipping_address => $shipping_address );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Shipment

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Shipment->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-shipment')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Shipment> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Shipment> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
