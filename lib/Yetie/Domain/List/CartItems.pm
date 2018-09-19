package Yetie::Domain::List::CartItems;
use Yetie::Domain::Base 'Yetie::Domain::List';

sub append {
    my $self = shift;
    $self->get_by_id( $_->id ) ? $self->_update_quantity($_) : $self->_append_item($_) for @_;
}

sub total_quantity {
    shift->list->reduce( sub { $a + $b->quantity }, 0 );
}

sub remove {
    my ( $self, $item_id ) = @_;
    return unless $self->list->has($item_id);

    my $new = $self->list->grep( sub { $_->id ne $item_id } );
    $self->list($new);
}

sub subtotal {
    my $self=shift;
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
            $item->id eq $_->id
              ? $item->quantity( $item->quantity + $_->quantity )
              : $_;
        }
    );
    $self->list($new);
}

1;
__END__

=head1 NAME

Yetie::Domain::List::CartItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::List::CartItems> inherits all attributes from L<Yetie::Domain::List> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::List::CartItems> inherits all methods from L<Yetie::Domain::List> and implements
the following new ones.

=head2 C<append>

    $items->append($item);
    $items->append( $item, $item, ... );

=head2 C<total_quantity>

    my $quantity = $items->total_quantity;

=head2 C<remove>

    $items->remove($item_id);

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
