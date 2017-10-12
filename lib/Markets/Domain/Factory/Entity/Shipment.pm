package Markets::Domain::Factory::Entity::Shipment;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # shipping_items
    my @shipping_items;
    foreach my $item ( @{ $self->{shipping_items} } ) {
        push @shipping_items, $self->factory('entity-selling_item')->create($item);
    }
    $self->param( shipping_items => collection(@shipping_items) );

    # shipping_address
    my $shipping_address = $self->factory('entity-address')->create( $self->{shipping_address} || {} );
    $self->param( shipping_address => $shipping_address );
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Shipment

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Shipment->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-shipment')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Shipment> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Markets::Domain::Factory::Entity::Shipment> inherits all methods from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
