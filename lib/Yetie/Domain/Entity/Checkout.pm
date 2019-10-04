package Yetie::Domain::Entity::Checkout;
use Yetie::Util;
use Carp qw(croak);

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has billing_address => (
    is      => 'rw',
    isa     => 'Yetie::Domain::Entity::Address',
    default => sub { shift->factory('entity-address')->construct() },
);
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

sub add_shipment_item {
    my $self = shift;
    my ( $index, $item ) = @_ > 1 ? ( shift, shift ) : ( 0, shift );
    croak 'First argument was not a Digit'   if $index =~ /\D/sxm;
    croak 'Second argument was not a Object' if ref $item =~ /::/sxm;

    my $shipment = $self->shipments->get($index);
    $shipment->items->append($item);
    return $self;
}

sub has_billing_address { return shift->billing_address->is_empty ? 0 : 1 }

sub has_shipping_address {
    my $self = shift;

    return 0 if !$self->shipments->has_shipment;
    return $self->shipments->first->shipping_address->is_empty ? 0 : 1;
}

sub has_shipping_item { return shift->shipments->has_item }

sub set_billing_address {
    my ( $self, $address ) = @_;
    croak 'Argument is missing.' if !$address;
    return if $self->billing_address->equals($address);

    $self->billing_address($address);
    return $self;
}

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

=head2 C<add_shipment_item>

    $checkout->add_shipment_item( $entity_item_object );
    $checkout->add_shipment_item( $index_no => $entity_item_object );

Return L<Yetie::Domain::Entity::Checkout> Object.

C<$index_no> is option argument.
Default $shipments->first

=head2 C<has_billing_address>

    my $bool = $checkout->has_billing_address;

Return boolean value.

=head2 C<has_shipping_address>

    my $bool = $checkout->has_shipping_address;

Return boolean value.

=head2 C<has_shipping_item>

    my $bool = $checkout->has_shipping_item;

Return boolean value.

=head2 C<set_billing_address>

    $checkout->set_billing_address( $address_obj );

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
