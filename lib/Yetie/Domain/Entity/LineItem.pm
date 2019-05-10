package Yetie::Domain::Entity::LineItem;
use Yetie::Domain::Base 'Yetie::Domain::Entity';

has hash => sub { shift->hash_code };
has product_id    => '';
has product_title => '';
has price         => 0;
has quantity      => 0;

sub equals { shift->hash eq shift->hash ? 1 : 0 }

sub hash_code {
    my $self = shift;

    my $str = '';
    $str .= $self->product_id;

    return $self->SUPER::hash_code($str);
}

sub subtotal {
    my $self     = shift;
    my $subtotal = 0;

    $subtotal = $self->price * $self->quantity;
    return $subtotal;
}

sub to_data {
    my $self = shift;

    my $data = $self->SUPER::to_data;
    delete $data->{hash};
    return $data;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::LineItem

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::LineItem> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<hash>

See L</hash_code>

=head2 C<product_id>

=head2 C<product_title>

=head2 C<quantity>

=head2 C<price>

=head1 METHODS

L<Yetie::Domain::Entity::LineItem> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<equals>

    my $bool = $item->equals($other_item);

=head2 C<hash_code>

    my $hash_code = $item->hash_code;

Return SHA1 string.
This method gets a string identifying items.

=head2 C<subtotal>

    $item->subtotal

Returns the combined price of all the items in the row.
This is equal to C< $item-E<gt>price> times C<$item-E<gt>quantity>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
