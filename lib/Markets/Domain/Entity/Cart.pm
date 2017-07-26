package Markets::Domain::Entity::Cart;
use Markets::Domain::Entity;
use Markets::Domain::Collection;
use Carp qw/croak/;

has id => sub { $_[0]->hash_code( $_[0]->cart_id ) };
has cart_id   => '';
has items     => sub { Markets::Domain::Collection->new };
has shipments => sub { Markets::Domain::Collection->new };
has [qw/billing_address/];

my @needless_attrs = (qw/cart_id items/);

# has 'items';
# has item_count       => sub { shift->items->flatten->size };
# has original_total_price => 0;
# has total_price          => 0;
# has total_weight         => 0;

# cart.attributes
# cart.item_count
# cart.items
# cart.note
# cart.original_total_price
# cart.total_price
# cart.total_weight

sub add_item {
    my ( $self, $item ) = @_;

    _add_item( $self->items, $item );

    $self->_is_modified(1);
    return $self;
}

sub add_shipping_item {
    my ( $self, $item, $shipment ) = @_;
    $shipment = $self->shipments->first unless $shipment;

    _add_item( $shipment->shipping_items, $item );

    $self->_is_modified(1);
    return $self;
}

sub all_shipping_items {
    shift->shipments->map( sub { $_->shipping_items->each } );
}

# NOTE: shipping_itemsにあるitemsも削除するべきか？
sub clear {
    my $self = shift;
    $self->items->each( sub { $self->remove_item( $_->id ) } );
}

sub count {
    my ( $self, $attr ) = @_;
    return $self->$attr->size;
}

sub grand_total {
    my $self        = shift;
    my $grand_total = $self->subtotal;

    # 送料計算等

    return $grand_total;
}

sub merge {
    my ( $self, $stored ) = ( shift->clone, shift->clone );

    # items
    foreach my $item ( @{ $stored->items } ) {
        $self->items->each(
            sub {
                my ( $e, $i ) = @_;
                if ( $e->is_equal($item) ) {
                    $item->quantity( $e->quantity + $item->quantity );
                    splice @{ $self->items }, $i, 1;
                }
            }
        );
    }
    push @{ $stored->items }, @{ $self->items };

    # shipments
    # NOTE: [WIP]
    # 未ログイン状態でshipmentsを設定している場合にどうするか。
    # - ログイン状態でshipmentsを設定している（カートに保存されている）
    # - ログアウト後に未ログイン状態でshipments設定まで進んだ後にログインする
    # 通常はその前にログインを促すのでありえない状態ではあるが...

    $stored->_is_modified(1);
    return $stored;
}

# NOTE: 数量は未考慮
sub remove_item {
    my ( $self, $item_id ) = @_;
    croak 'Argument was not a Scalar' if ref \$item_id ne 'SCALAR';

    my $removed;
    my $collection = $self->items->grep( sub { $_->id eq $item_id ? ( $removed = $_ and 0 ) : 1 } );
    $self->items($collection) if $removed;

    $removed ? $self->_is_modified(1) : $self->_is_modified(0);
    return $removed;
}

# NOTE: 数量は未考慮
sub remove_shipping_item {
    my ( $self, $index, $item_id ) = @_;
    croak 'First argument was not a Digit'   if $index =~ /\D/;
    croak 'Second argument was not a Scalar' if ref \$item_id ne 'SCALAR';

    my $removed = $self->shipments->[$index]->remove_shipping_item($item_id);
    $removed ? $self->_is_modified(1) : $self->_is_modified(0);
    return $removed;
}

sub subtotal {
    my $self     = shift;
    my $subtotal = 0;

    $subtotal += $self->items->reduce( sub { $a + $b->subtotal }, 0 );
    $subtotal += $self->shipments->reduce( sub { $a + $b->subtotal }, 0 );

    return $subtotal;
}

sub to_order_data {
    my $self = shift;
    my $data = $self->to_data;

    # Remove needless data
    delete $data->{$_} for @needless_attrs;
    return $data;
}

sub total_item_count {

    # $_[0]->items->size + $_[0]->shipments->reduce( sub { $a + $b->item_count }, 0 );
    $_[0]->count('items') + $_[0]->count('all_shipping_items');
}

sub total_quantity {
    $_[0]->items->reduce( sub { $a + $b->quantity }, 0 ) +
      $_[0]->shipments->reduce( sub { $a + $b->subtotal_quantity }, 0 );
}

sub _add_item {
    my $collection = shift;
    my $item       = shift;

    my $exsist_item = $collection->find( $item->id );
    if ($exsist_item) {
        my $qty = $exsist_item->quantity + $item->quantity;
        $exsist_item->quantity($qty);
    }
    else {
        push @{$collection}, $item;
    }
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Cart

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Cart> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<billing_address>

=head2 C<cart_id>

=head2 C<id>

=head2 C<items>

    my $items = $cart->items;
    $items->each( sub { ... } );

Return L<Markets::Domain::Collection> object.
Elements is L<Markets::Domain::Entity::Item> object.

=head2 C<shipments>

    my $shipments = $cart->shipments;
    $shipments->each( sub { ... } );

Return L<Markets::Domain::Collection> object.
Elements is L<Markets::Domain::Entity::Cart::Shipment> object.

=head1 METHODS

L<Markets::Domain::Entity::Cart> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<add_item>

    $cart->add_item( $item_entity_object );

Return L<Markets::Domain::Entity::Cart> Object.

=head2 C<add_shipping_item>

    $cart->add_shipping_item( $item_entity_object );
    $cart->add_shipping_item( $item_entity_object, $shipment_object );

Return L<Markets::Domain::Entity::Cart> Object.

C<$shipment_object> is option argument.
default $shipments->first

=head2 C<all_shipping_items>

    my $all_shipping_items = $cart->all_shipping_items;

All items in shipments.

=head2 C<clear>

    $cart->clear;

Remove all items.

=head2 C<clone>

=head2 C<count>

=head2 C<grand_total>

=head2 C<is_modified>

    my $bool = $cart->is_modified;

Return boolean value.

=head2 C<merge>

    my $merged = $cart->merge($stored_cart);

Return Entity Cart Object.

=head2 C<remove_item>

    my $removed = $cart->remove_item($item_id);

Return L<Markets::Domain::Entity::Cart::Item> object or undef.

=head2 C<remove_shipping_item>

    my $removed = $cart->remove_shipping_item($index, $item_id);

Return L<Markets::Domain::Entity::Cart::Item> object or undef.

=head2 C<subtotal>

    my $subtotal = $cart->subtotal;

=head2 C<to_order_data>

    my $order = $self->to_order_data;

=head2 C<total_item_count>

    my $item_count = $cart->total_item_count;

Return number of items types.

=head2 C<total_quantity>

    my $total_qty = $cart->total_quantity;

Return all items quantity.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>, L<Markets::Domain::Entity::Cart::Shipment>, L<Markets::Domain::Entity::Cart::Item>
