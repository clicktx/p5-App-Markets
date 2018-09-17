package Yetie::Domain::List::CartItems;
use Yetie::Domain::Base 'Yetie::Domain::List';

sub total_quantity {
    shift->list->reduce( sub { $a + $b->quantity }, 0 );
}

sub remove {
    my ( $self, $item_id ) = @_;
    return $self->grep( sub { $_->id ne $item_id } );
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

=head2 C<total_quantity>

    my $quantity = $items->total_quantity;

=head2 C<remove>

    my $new = $items->remove($item_id);

Return L<Yetie::Domain::List::CartItems> object.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity::Item>, L<Yetie::Domain::List>
