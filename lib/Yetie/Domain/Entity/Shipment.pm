package Yetie::Domain::Entity::Shipment;
use Yetie::Domain::Entity;
use Data::Clone qw/data_clone/;
use Yetie::Domain::Collection;
use Yetie::Domain::Entity::Address;

has shipping_address => sub { Yetie::Domain::Entity::Address->new };
has shipping_items   => sub { Yetie::Domain::Collection->new };

sub clone {
    my $self  = shift;
    my $clone = data_clone($self);
    $clone->shipping_items( $self->shipping_items->map( sub { $_->clone } ) )
      if $self->shipping_items->can('map');
    $clone->_is_modified(0);
    return $clone;
}

sub item_count { shift->shipping_items->size }

sub subtotal_quantity {
    shift->shipping_items->reduce( sub { $a + $b->quantity }, 0 );
}

sub subtotal {
    shift->shipping_items->reduce( sub { $a + $b->subtotal }, 0 );
}

1;
__END__

=head1 NAME

Yetie::Domain::Entity::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Entity::Shipment> inherits all attributes from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<shipping_address>

Return L<Yetie::Domain::Entity::Address> object.

=head2 C<shipping_items>

Return L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::Shipment> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

=head2 C<item_count>

=head2 C<subtotal_quantity>

=head2 C<subtotal>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
