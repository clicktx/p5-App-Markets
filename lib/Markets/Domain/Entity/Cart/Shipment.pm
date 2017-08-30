package Markets::Domain::Entity::Cart::Shipment;
use Markets::Domain::Entity;
use Data::Clone qw/data_clone/;
use Carp qw/croak/;

has shipping_items => sub { Markets::Domain::Collection->new };
has [qw/id shipping_address/];

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

Markets::Domain::Entity::Cart::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Cart::Shipment> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<id>

=head2 C<shipping_address>

=head2 C<shipping_items>

=head1 METHODS

L<Markets::Domain::Entity::Cart::Shipment> inherits all methods from L<Markets::Domain::Entity> and implements
the following new ones.

=head2 C<clone>

=head2 C<item_count>

=head2 C<subtotal_quantity>

=head2 C<subtotal>

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Domain::Entity>
