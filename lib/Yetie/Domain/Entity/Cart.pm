package Yetie::Domain::Entity::Cart;
use Yetie::Domain::Base 'Yetie::Domain::Entity';
use Carp qw(croak);
use Yetie::Util;

has id => sub { $_[0]->hash_code( $_[0]->cart_id ) };
has cart_id         => '';
has email           => sub { __PACKAGE__->factory('value-email')->construct() };
has billing_address => sub { __PACKAGE__->factory('entity-address')->construct() };
has items           => sub { __PACKAGE__->factory('list-cart_items')->construct() };
has shipments       => sub { __PACKAGE__->factory('list-shipments')->construct() };

my @needless_attrs = (qw/cart_id items/);

sub add_item {
    my ( $self, $item ) = @_;
    croak 'Argument was not a Object' if ref $item =~ /::/;

    $self->items->append($item);
}

sub add_shipping_item {
    my ( $self, $index, $item ) = @_;
    croak 'First argument was not a Digit'   if $index =~ /\D/;
    croak 'Second argument was not a Object' if ref $item =~ /::/;

    my $shipment = $self->shipments->get($index);
    $shipment->items->append($item);
}

sub clear_items {
    my $self = shift;
    $self->items->clear;
    $self->shipments->clear_items;
}

sub grand_total {
    my $self        = shift;
    my $grand_total = $self->subtotal;

    # 送料計算等

    return $grand_total;
}

sub has_billing_address { shift->billing_address->is_empty ? 0 : 1 }

sub merge {
    my ( $self, $target ) = @_;
    my ( $clone, $stored ) = ( $self->clone, $target->clone );

    # items
    foreach my $item ( @{ $stored->items->list } ) {
        $clone->items->each(
            sub {
                my ( $e, $num ) = @_;
                if ( $e->equal($item) ) {
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

    $stored->_is_modified(1);
    return $stored;
}

sub move_items_to_first_shipment {
    my $self = shift;

    my $items = $self->items->to_array;
    $self->shipments->first->items->append( @{$items} );
}

# NOTE: 数量は未考慮
sub remove_item {
    my ( $self, $item_id ) = @_;
    croak 'Argument was not a Scalar' if ref \$item_id ne 'SCALAR';

    $self->items->remove($item_id);
}

# NOTE: 数量は未考慮
sub remove_shipping_item {
    my ( $self, $index, $item_id ) = @_;
    croak 'First argument was not a Digit'   if $index =~ /\D/;
    croak 'Second argument was not a Scalar' if ref \$item_id ne 'SCALAR';

    my $shipment = $self->shipments->get($index);
    $shipment->items->remove($item_id);
}

sub revert { shift->shipments->revert }

sub set_billing_address {
    my ( $self, $address ) = @_;
    croak 'Argument is missing.' unless $address;
    return if $self->billing_address->equal($address);

    $self->billing_address($address);
}

sub set_shipping_address {
    my $self = shift;
    croak 'Argument is missing.' unless @_;

    # Convert arguments
    my $addresses = @_ > 1 ? +{@_} : Yetie::Util::array_to_hash(@_);

    # Has not shipment in shipments
    $self->shipments->create_shipment unless $self->shipments->has_shipment;

    my $cnt = 0;
    foreach my $index ( keys %{$addresses} ) {
        my $address  = $addresses->{$index};
        my $shipment = $self->shipments->get($index);

        next if $shipment->shipping_address->equal($address);
        $shipment->shipping_address($address);
        $cnt++;
    }
    return $cnt;
}

sub subtotal {
    my $self = shift;
    return $self->items->subtotal + $self->shipments->subtotal;
}

sub to_order_data {
    my $self = shift;
    my $data = $self->to_data;

    # Remove needless data
    delete $data->{$_} for @needless_attrs;
    return $data;
}

sub total_item_size {
    my $self = shift;
    return $self->items->size + $self->shipments->total_item_size;
}

sub total_quantity {
    my $self = shift;
    $self->items->total_quantity + $self->shipments->total_quantity;
}

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

Return L<Yetie::Domain::List::CartItems> object.
Elements is L<Yetie::Domain::Entity::Cart::Item> object.

=head2 C<shipments>

    my $shipments = $cart->shipments;
    $shipments->each( sub { ... } );

Return L<Yetie::Domain::Collection> object.
Elements is L<Yetie::Domain::Entity::Shipment> object.

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

=head2 C<has_billing_address>

    my $bool = $cart->has_billing_address;

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

    $cart->remove_item($item_id);

=head2 C<remove_shipping_item>

    $cart->remove_shipping_item($shipment_index, $item_id);

=head2 C<revert>

    $cart->revert;

Delete except the first shipping-information. Also delete all shipping-items of the first shipping-information.

See L<Yetie::Domain::List::Shipments/revert>.

=head2 C<subtotal>

    my $subtotal = $cart->subtotal;

=head2 C<to_order_data>

    my $order = $self->to_order_data;

=head2 C<total_item_size>

    my $item_size = $cart->total_item_size;

Return number of items types.

=head2 C<total_quantity>

    my $total_qty = $cart->total_quantity;

Return all items quantity.

=head2 C<set_billing_address>

    $cart->set_billing_address( $address_obj );

=head2 C<set_shipping_address>

    # Update first element
    $cart->set_shipping_address( $address_obj );

    # Update multiple elements
    $cart->set_shipping_address( 1 => $address_obj, 3 => $address_obj, ... );
    $cart->set_shipping_address( [ $address_obj, $address_obj, ... ] );

Update shipping address.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>, L<Yetie::Domain::List::CartItems>, L<Yetie::Domain::Entity::Cart::Item>,
L<Yetie::Domain::Entity::Shipment>
