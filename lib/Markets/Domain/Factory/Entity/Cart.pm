package Markets::Domain::Factory::Entity::Cart;
use Mojo::Base 'Markets::Domain::Factory';
use Mojo::Collection qw/c/;

sub construct {
    my $self = shift;

    my $items = $self->cart_data->{items} || [];
    my $shipments = $self->cart_data->{shipments} || [ {} ];

    my @shipments;
    for ( my $i = 0 ; $i < @{$items} ; $i++ ) {
        my %ship = %{ $shipments->[$i] };
        $ship{items} = $self->_shipment_items( $items->[$i] );
        push @shipments, $self->app->factory( 'entity-shipment', \%ship );
    }

    return $self->construct_class->new(
        {
            cart_id   => $self->cart_id,
            shipments => c(@shipments),
        }
    );
}

sub _shipment_items {
    my $self       = shift;
    my $line_items = shift;

    my @shipment_items;
    foreach my $item ( @{$line_items} ) {
        my $entity_item = $self->app->factory( 'entity-item', $item );
        push @shipment_items, $entity_item;
    }

    return c(@shipment_items);
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Cart

=head1 SYNOPSIS

    # In controller
    my $obj = $c->factory( 'entity-cart', %args );

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Cart> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
