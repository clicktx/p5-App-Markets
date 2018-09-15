package Yetie::Domain::Entity::Shipment;
use Yetie::Domain::Base 'Yetie::Domain::Entity';
use Data::Clone qw/data_clone/;
use Yetie::Domain::List::CartItems;

has shipping_address => sub { __PACKAGE__->factory('entity-address')->construct() };
has items            => sub { Yetie::Domain::List::CartItems->new };

sub clone {
    my $self  = shift;
    my $clone = data_clone($self);
    $clone->items( $self->items->map( sub { $_->clone } ) )
      if $self->items->can('map');
    $clone->_is_modified(0);
    return $clone;
}

sub item_count { shift->items->size }

sub subtotal {
    shift->items->reduce( sub { $a + $b->subtotal }, 0 );
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

=head2 C<items>

Return L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Entity::Shipment> inherits all methods from L<Yetie::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

=head2 C<item_count>

=head2 C<subtotal>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Domain::Entity>
