package Yetie::Domain::Entity::SellingItems;
use Yetie::Domain::Entity;

has item_list => sub { __PACKAGE__->collection };

sub each { shift->item_list->each(@_) }

sub total_amount {
    my $self = shift;

    my $total_amount = 0;
    $self->item_list->each( sub { $total_amount += $_->subtotal } );
    return $total_amount;
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::SellingItems

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::SellingItems> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<item_list>

Return C<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::SellingItems> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<each>

    $items->each( sub{ ... } );

alias method $items->item_list->each()

=head2 C<total_amount>

    my $total_amount = $items->total_amount;

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
