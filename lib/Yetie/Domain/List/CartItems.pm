package Yetie::Domain::List::CartItems;
use Moose;
use namespace::autoclean;
extends 'Yetie::Domain::List::LineItems';

has _item_isa => ( default => 'Yetie::Domain::Entity::CartItem' );

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

Yetie::Domain::List::CartItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::CartItems> inherits all attributes from L<Yetie::Domain::List::LineItems> and implements
the following new ones.

=head2 C<subtotal_excl_tax>

    my $subtotal_excl_tax = $items->subtotal_excl_tax;

=head2 C<subtotal_incl_tax>

    my $subtotal_incl_tax = $items->subtotal_incl_tax;

=head1 METHODS

L<Yetie::Domain::List::CartItems> inherits all methods from L<Yetie::Domain::List::LineItems> and implements
the following new ones.

=head2 C<append>

    $items->append($item);
    $items->append( $item, $item, ... );

=head2 C<get_by_product_hash_code>

    my $item = $items->get_by_product_hash_code($item_hash_sum);

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

L<Yetie::Domain::Entity::CartItem>, L<Yetie::Domain::List::LineItems>, L<Yetie::Domain::List>
