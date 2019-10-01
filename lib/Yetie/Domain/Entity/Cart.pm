package Yetie::Domain::Entity::Cart;
use Carp qw(croak);
use Yetie::Util;
use Mojo::Util qw/sha1_sum/;

use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::Entity';

has id => (
    is      => 'ro',
    lazy    => 1,
    default => sub { sha1_sum( shift->cart_id ) }
);
has cart_id => (
    is      => 'ro',
    default => q{}
);
has billing_address => (
    is      => 'rw',
    default => sub { __PACKAGE__->factory('entity-address')->construct() }
);
has items => (
    is      => 'ro',
    default => sub { __PACKAGE__->factory('list-line_items')->construct() }
);
has shipments => (
    is      => 'ro',
    default => sub { __PACKAGE__->factory('list-shipments')->construct() }
);
has _total_amounts => (
    is         => 'ro',
    isa        => 'Yetie::Domain::List::TotalAmounts',
    lazy_build => 1,
    reader     => 'total_amounts',
    init_arg   => undef,
);

sub _build__total_amounts {
    my $self = shift;

    my $total_amounts = $self->factory('list-total_amounts')->construct();
    $self->items->each( sub { $total_amounts->sum($_) } );
    return $total_amounts;
}

sub add_item {
    my ( $self, $item ) = @_;
    croak 'Argument was not a Object' if ref $item =~ /::/sxm;

    $self->items->append($item);
    return $self;
}

sub add_shipping_item {
    my ( $self, $index, $item ) = @_;
    croak 'First argument was not a Digit'   if $index =~ /\D/sxm;
    croak 'Second argument was not a Object' if ref $item =~ /::/sxm;

    my $shipment = $self->shipments->get($index);
    $shipment->items->append($item);
    return $self;
}

sub clear_items {
    my $self = shift;

    $self->items->clear;
    $self->shipments->clear_items;
    return $self;
}

# NOTE: 送料計算等はどうなる？
sub grand_total { shift->total_amounts->grand_total }

sub has_billing_address { return shift->billing_address->is_empty ? 0 : 1 }

sub has_item { return shift->items->size ? 1 : 0 }

sub has_shipping_address {
    my $self = shift;

    return 0 if !$self->shipments->has_shipment;
    return $self->shipments->first->shipping_address->is_empty ? 0 : 1;
}

sub has_shipping_item { return shift->shipments->has_item }

sub merge {
    my ( $self, $target ) = @_;
    my ( $clone, $stored ) = ( $self->clone, $target->clone );

    # items
    foreach my $item ( @{ $stored->items->list } ) {
        $clone->items->each(
            sub {
                my ( $e, $num ) = @_;
                if ( $e->equals($item) ) {
                    $item->quantity( $e->quantity + $item->quantity );
                    my $i = $num - 1;
                    splice @{ $clone->items->list }, $i, 1;
                }
            }
        );
    }
    push @{ $stored->items->list }, @{ $clone->items->list };

    # shipments
    # NOTE: [WIP]
    # 未ログイン状態でshipmentsを設定している場合にどうするか。
    # - ログイン状態でshipmentsを設定している（カートに保存されている）
    # - ログアウト後に未ログイン状態でshipments設定まで進んだ後にログインする
    # 通常はその前にログインを促すのでありえない状態ではあるが...

    # $stored->_is_modified(1);
    return $stored;
}

sub move_items_to_first_shipment {
    my $self = shift;

    my $items = $self->items->to_array;
    $self->shipments->first->items->append( @{$items} );
    return $self;
}

# NOTE: 数量は未考慮
sub remove_item {
    my ( $self, $line_num ) = @_;
    croak 'Argument was not a Scalar' if $line_num =~ /\D/sxm;

    return $self->items->remove($line_num);
}

# NOTE: 数量は未考慮
sub remove_shipping_item {
    my ( $self, $index, $line_num ) = @_;
    croak 'First argument was not a Digit'   if $index =~ /\D/sxm;
    croak 'Second argument was not a Scalar' if $line_num =~ /\D/sxm;

    my $shipment = $self->shipments->get($index);
    return 0 if !$shipment;

    return $shipment->items->remove($line_num);
}

sub revert {
    my $self = shift;
    return if !$self->shipments->has_item;

    $self->shipments->revert;
    return $self;
}

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

sub subtotal_excl_tax { return shift->items->subtotal_excl_tax }

sub subtotal_incl_tax { return shift->items->subtotal_incl_tax }

sub taxes { return shift->total_amounts->taxes }

sub to_order_data {
    my $self = shift;
    my $data = $self->to_data;

    # Remove needless data
    for (qw/id cart_id items/) { delete $data->{$_} }

    # Billing Address
    $data->{billing_address} = { id => $data->{billing_address}->{id} };

    # Shipments
    foreach my $shipment ( @{ $data->{shipments} } ) {
        my $id = $shipment->{shipping_address}->{id};
        $shipment->{shipping_address} = { id => $id };
    }

    # Rename shipments to orders
    $data->{orders} = delete $data->{shipments};
    return $data;
}

sub count_total_items { return shift->items->size }

sub total_quantity { return shift->items->total_quantity }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Cart> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<billing_address>

=head2 C<cart_id>

=head2 C<id>

=head2 C<items>

    my $items = $cart->items;
    $items->each( sub { ... } );

Return L<Yetie::Domain::List::LineItems> object.
Elements is L<Yetie::Domain::Entity::LineItem> object.

=head2 C<shipments>

    my $shipments = $cart->shipments;
    $shipments->each( sub { ... } );

Return L<Yetie::Domain::Collection> object.
Elements is L<Yetie::Domain::Entity::Shipment> object.

=head2 C<total_amounts>

    my $total_amounts = $cart->total_amounts;

Return L<Yetie::Domain::List::TotalAmounts> object.

=head1 METHODS

L<Yetie::Domain::Entity::Cart> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<add_item>

    $cart->add_item( $entity_item_object );

Return L<Yetie::Domain::Entity::Cart> Object.

=head2 C<add_shipping_item>

    $cart->add_shipping_item( $entity_item_object );
    $cart->add_shipping_item( $index, $entity_item_object );

Return L<Yetie::Domain::Entity::Cart> Object.

C<$shipment_object> is option argument.
default $shipments->first

=head2 C<clear_items>

    $cart->clear_items;

Remove all items.

=head2 C<clone>

=head2 C<grand_total>

Calculate the total amount of all.

    my $grand_total = $cart->grand_total;

Return L<Yetie::Domain::Value::Price> object.

=head2 C<has_billing_address>

    my $bool = $cart->has_billing_address;

Return boolean value.

=head2 C<has_item>

    my $bool = $cart->has_item;

Return boolean value.

=head2 C<has_shipping_address>

    my $bool = $cart->has_shipping_address;

Return boolean value.

=head2 C<has_shipping_item>

    my $bool = $cart->has_shipping_item;

Return boolean value.

=head2 C<is_modified>

    my $bool = $cart->is_modified;

Return boolean value.

=head2 C<merge>

    my $merged = $cart->merge($stored_cart);

Return Entity Cart Object.

=head2 C<move_items_to_first_shipment>

    $cart->move_items_to_first_shipment;

Move all items to the first element of C<Yetie::Domain::List::Shipments>.

=head2 C<remove_item>

    $cart->remove_item($line_num);

Return true if removed item.

=head2 C<remove_shipping_item>

    $cart->remove_shipping_item($shipment_index => $line_num);

Return true if removed item.

=head2 C<revert>

    $cart->revert;

Delete except the first shipping-information. Also delete all shipping-items of the first shipping-information.

See L<Yetie::Domain::List::Shipments/revert>.

=head2 C<set_billing_address>

    $cart->set_billing_address( $address_obj );

=head2 C<set_shipping_address>

    # Update first element
    $cart->set_shipping_address( $address_obj );

    # Update multiple elements
    $cart->set_shipping_address( 1 => $address_obj, 3 => $address_obj, ... );
    $cart->set_shipping_address( [ $address_obj, $address_obj, ... ] );

Update shipping address.

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $cart->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $cart->subtotal_incl_tax;

=head2 C<to_order_data>

    my $order = $self->to_order_data;

=head2 C<count_total_items>

    my $item_count = $cart->count_total_items;

Return number of items types.

=head2 C<taxes>

All tax calculation result.

    my $taxes = $cart->taxes;

Return L<Yetie::Domain::Value::Tax> object.

=head2 C<total_quantity>

    my $total_qty = $cart->total_quantity;

Return all items quantity.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>, L<Yetie::Domain::List::Linetems>, L<Yetie::Domain::Entity::LineItem>,
L<Yetie::Domain::Entity::Shipment>, L<Yetie::Domain::List::TotalAmounts>
