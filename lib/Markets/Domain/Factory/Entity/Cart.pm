package Markets::Domain::Factory::Entity::Cart;
use Mojo::Base 'Markets::Domain::Factory';
use Markets::Domain::Collection qw/collection/;

sub cook {
    my $self = shift;

    # billing_address
    my $billing_address = $self->factory('entity-address')->create( $self->{billing_address} || {} );
    $self->param( billing_address => $billing_address );

    # Aggregate items
    $self->_create_entity( 'items', 'entity-item', $self->param('items') || [] );

    # Aggregate shipments
    my $param = $self->param('shipments') || [ {} ];
    push @{$param}, {} unless @{$param};    # NOTE: At the time of "$param eq []"
    $self->_create_entity( 'shipments', 'entity-shipment', $param );
}

sub _create_entity {
    my ( $self, $aggregate, $entity, $data ) = @_;
    my @array;
    push @array, $self->factory($entity)->create($_) for @{$data};
    $self->param( $aggregate => collection(@array) );
}

1;
__END__

=head1 NAME

Markets::Domain::Factory::Entity::Cart

=head1 SYNOPSIS

    my $entity = Markets::Domain::Factory::Entity::Cart->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-cart')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Factory::Entity::Cart> inherits all attributes from L<Markets::Domain::Factory> and implements
the following new ones.

=head1 METHODS

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Markets::Domain::Factory>
