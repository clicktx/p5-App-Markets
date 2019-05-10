package Yetie::Domain::List::LineItems;
use Yetie::Domain::Base 'Yetie::Domain::List';

sub append {
    my $self = shift;
    $self->get_by_hash( $_->hash ) ? $self->_update_quantity($_) : $self->_append_item($_) for @_;
}

sub get_by_hash {
    my ( $self, $hash_code ) = @_;
    return $self->list->first( sub { $_->hash eq $hash_code } );
}

sub has_element_by_hash { shift->get_by_hash(shift) ? 1 : 0 }

sub total_quantity {
    shift->list->reduce( sub { $a + $b->quantity }, 0 );
}

sub remove {
    my ( $self, $hash_code ) = @_;
    return unless $self->has_element_by_hash($hash_code);

    my $new = $self->list->grep( sub { $_->hash ne $hash_code } );
    $self->list($new);
}

sub subtotal {
    my $self = shift;
    $self->list->reduce( sub { $a + $b->subtotal }, 0 );
}

sub _append_item {
    my ( $self, $item ) = @_;
    my $new = $self->list->append($item);
    $self->list($new);
}

sub _update_quantity {
    my ( $self, $item ) = @_;
    my $new = $self->list->map(
        sub {
            $item->hash eq $_->hash
              ? $item->quantity( $item->quantity + $_->quantity )
              : $_;
        }
    );
    $self->list($new);
}

1;
__END__

=head1 NAME

Yetie::Domain::List::LineItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::LineItems> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::LineItems> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<append>

    $items->append($item);
    $items->append( $item, $item, ... );

=head2 C<get_by_hash>

    my $item = $items->get_by_hash($hash_code);

=head2 C<has_element_by_hash>

    my $bool = $items->has_element_by_hash($hash_code);

=head2 C<total_quantity>

    my $quantity = $items->total_quantity;

=head2 C<remove>

    $items->remove($hash_code);

=head2 C<subtotal>

    my $subtotal = $items->subtotal;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
