package Yetie::Domain::List::LineItems;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List';

has _subtotal_excl_tax => (
    is       => 'ro',
    isa      => 'Yetie::Domain::Value::Price',
    lazy     => 1,
    builder  => '_build__subtotal_excl_tax',
    reader   => 'subtotal_excl_tax',
    init_arg => undef,
);

has _subtotal_incl_tax => (
    is       => 'ro',
    isa      => 'Yetie::Domain::Value::Price',
    lazy     => 1,
    builder  => '_build__subtotal_incl_tax',
    reader   => 'subtotal_incl_tax',
    init_arg => undef,
);

sub _init_price {
    my $self = shift;

    return $self->size
      ? $self->first->price->clone( value => 0 )
      : Yetie::Factory->new('value-price')->construct;
}

sub _build__subtotal_excl_tax {
    my $self = shift;

    my $price = $self->_init_price;
    return $self->reduce( sub { $a + $b->row_total_excl_tax }, $price );
}

sub _build__subtotal_incl_tax {
    my $self = shift;

    my $price = $self->_init_price;
    return $self->reduce( sub { $a + $b->row_total_incl_tax }, $price );
}

sub append {
    my $self = shift;

    foreach my $item (@_) {
        $self->get_by_product_hash_code( $item->product_hash_code )
          ? $self->_update_quantity($item)
          : $self->_append_item($item);
    }
    return $self;
}

sub get_by_product_hash_code {
    my ( $self, $hash_code ) = @_;
    return $self->first( sub { $_->product_hash_code eq $hash_code } );
}

sub has_element_by_hash { return shift->get_by_product_hash_code(shift) ? 1 : 0 }

sub total_quantity {
    return shift->reduce( sub { $a + $b->quantity }, 0 );
}

sub remove {
    my ( $self, $line_num ) = @_;

    my $item = $self->get_by_line_num($line_num);
    return 0 if !$item;

    my $new = $self->grep( sub { !$_->equals($item) } );
    $self->list($new);
    return 1;
}

sub _append_item {
    my ( $self, $item ) = @_;
    my $new = $self->list->append($item);
    return $self->list($new);
}

sub _update_quantity {
    my ( $self, $item ) = @_;
    my $new = $self->map(
        sub {
            if ( $_->equals($item) ) { $_->quantity( $_->quantity + $item->quantity ) }
            return $_;
        }
    );
    return $self->list($new);
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::LineItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::LineItems> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $items->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $items->subtotal_incl_tax;

=head1 METHODS

L<Yetie::Domain::List::LineItems> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<append>

    $items->append($item);
    $items->append( $item, $item, ... );

=head2 C<get_by_product_hash_code>

    my $item = $items->get_by_product_hash_code($product_hash_code);

=head2 C<has_element_by_hash>

    my $bool = $items->has_element_by_hash($hash_code);

=head2 C<total_quantity>

    my $quantity = $items->total_quantity;

=head2 C<remove>

    $items->remove($line_num);

Return true if remove item.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
