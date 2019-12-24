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
has items => (
    is      => 'ro',
    default => sub { __PACKAGE__->factory('list-cart_items')->construct() }
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

sub clear_items {
    my $self = shift;

    $self->items->clear;
    return $self;
}

# NOTE: 送料計算等はどうなる？
sub grand_total { shift->total_amounts->grand_total }

sub has_item { return shift->items->size ? 1 : 0 }

sub merge {
    my ( $self, $target ) = @_;
    my ( $clone, $stored ) = ( $self->clone, $target->clone );

    # items
    foreach my $item ( @{ $stored->items->list } ) {
        $clone->items->each(
            sub {
                my ( $e, $num ) = @_;
                if ( $e->equals($item) ) {
                    $item->set_quantity( $e->quantity + $item->quantity );
                    my $i = $num - 1;
                    splice @{ $clone->items->list }, $i, 1;
                }
            }
        );
    }
    push @{ $stored->items->list }, @{ $clone->items->list };

    return $stored;
}

# NOTE: 数量は未考慮
sub remove_item {
    my ( $self, $line_num ) = @_;
    croak 'Argument was not a Scalar' if $line_num =~ /\D/sxm;

    return $self->items->remove($line_num);
}

sub subtotal_excl_tax { return shift->items->subtotal_excl_tax }

sub subtotal_incl_tax { return shift->items->subtotal_incl_tax }

sub taxes { return shift->total_amounts->taxes }

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

=head2 C<cart_id>

=head2 C<id>

=head2 C<items>

    my $items = $cart->items;
    $items->each( sub { ... } );

Return L<Yetie::Domain::List::CartItems> object.
Elements is L<Yetie::Domain::Entity::CartItem> object.

=head2 C<total_amounts>

    my $total_amounts = $cart->total_amounts;

Return L<Yetie::Domain::List::TotalAmounts> object.

=head1 METHODS

L<Yetie::Domain::Entity::Cart> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<add_item>

    $cart->add_item( $entity_item_object );

Return L<Yetie::Domain::Entity::Cart> Object.

=head2 C<clear_items>

    $cart->clear_items;

Remove all items.

=head2 C<clone>

=head2 C<grand_total>

Calculate the total amount of all.

    my $grand_total = $cart->grand_total;

Return L<Yetie::Domain::Value::Price> object.

=head2 C<has_item>

    my $bool = $cart->has_item;

Return boolean value.

=head2 C<is_modified>

    my $bool = $cart->is_modified;

Return boolean value.

=head2 C<merge>

    my $merged = $cart->merge($stored_cart);

Return Entity Cart Object.

=head2 C<remove_item>

    $cart->remove_item($line_num);

Return true if removed item.

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $cart->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $cart->subtotal_incl_tax;

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

L<Yetie::Domain::List::CartItems>, L<Yetie::Domain::Entity::CartItem>,
L<Yetie::Domain::List::TotalAmounts>, L<Yetie::Domain::Entity>
