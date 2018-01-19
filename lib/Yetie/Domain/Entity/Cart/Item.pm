package Yetie::Domain::Entity::Cart::Item;
use Yetie::Domain::Entity;

has id => sub { shift->hash_code };
has product_id    => '';
has product_title => '';
has price         => 0;
has quantity      => 0;

sub hash_code {
    my $self  = shift;
    my $bytes = $self->product_id;

    # $bytes .= ...;
    $self->SUPER::hash_code($bytes);
}

sub subtotal {
    my $self     = shift;
    my $subtotal = 0;

    $subtotal = $self->price * $self->quantity;
    return $subtotal;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Cart::Item

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Cart::Item> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<id>

=head2 C<product_id>

=head2 C<product_title>

=head2 C<quantity>

=head2 C<price>

=head1 METHODS

L<Yetie::Domain::Entity::Cart::Item> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<subtotal>

    $item->subtotal

Returns the combined price of all the items in the row.
This is equal to C< $item-E<gt>price> times C<$item-E<gt>quantity>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>