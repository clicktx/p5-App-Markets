package Markets::Domain::Entity::Shipment;
use Markets::Domain::Entity;
use Markets::Domain::Collection;
use Data::Clone qw/data_clone/;

has id => sub { shift->hash_code };
has shipping_address => '';
has shipping_items => sub { Markets::Domain::Collection->new };

sub clone {
    my $self  = shift;
    my $clone = data_clone($self);
    $clone->shipping_items( $self->shipping_items->map( sub { $_->clone } ) )
      if $self->shipping_items->can('map');
    $clone->_is_modified(0);
    return $clone;
}

sub hash_code {
    my $self  = shift;
    my $bytes = $self->shipping_address;

    # $bytes .= ...
    $self->SUPER::hash_code($bytes);
}

sub item_count { shift->shipping_items->size }

sub subtotal_quantity {
    shift->shipping_items->reduce( sub { $a + $b->quantity }, 0 );
}

1;
__END__

=head1 NAME

Markets::Domain::Entity::Shipment

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Entity::Shipment> inherits all attributes from L<Markets::Domain::Entity> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Entity>
