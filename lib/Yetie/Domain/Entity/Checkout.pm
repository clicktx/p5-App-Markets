package Yetie::Domain::Entity::Checkout;
use Yetie::Util;
use Carp qw(croak);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has shipments => (
    is      => 'ro',
    isa     => 'Yetie::Domain::List::Shipments',
    default => sub { shift->factory('list-shipments')->construct() },
);
has transaction => (
    is      => 'ro',
    isa     => 'Yetie::Domain::Entity::Transaction',
    default => sub { shift->factory('entity-transaction')->construct() },
);

sub set_shipping_address {
    my $self = shift;
    croak 'Argument is missing.' if !@_;

    # Convert arguments
    my $addresses = @_ > 1 ? +{@_} : Yetie::Util::array_to_hash(@_);

    # Has not shipment in shipments
    if ( !$self->shipments->has_shipment ) { $self->shipments->create_shipment }

    foreach my $index ( keys %{$addresses} ) {
        my $address  = $addresses->{$index};
        my $shipment = $self->shipments->get($index);

        next if $shipment->shipping_address->equals($address);
        $shipment->shipping_address($address);
    }
    return $self;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Checkout

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Checkout> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<transaction>

    my $transaction = $checkout->transaction;

Return L<Yetie::Domain::Entity::Transaction> object.

=head1 METHODS

L<Yetie::Domain::Entity::Checkout> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<set_shipping_address>

    # Update first element
    $checkout->set_shipping_address( $address_obj );

    # Update multiple elements
    $checkout->set_shipping_address( 1 => $address_obj, 3 => $address_obj, ... );
    $checkout->set_shipping_address( [ $address_obj, $address_obj, ... ] );

Update shipping address.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Cart>, L<Yetie::Domain::Entity::Transaction>, L<Yetie::Domain::Entity>
