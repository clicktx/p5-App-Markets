package Yetie::Domain::Factory::Entity::Cart;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # email
    $self->aggregate( email => 'value-email', $self->{email} || '' );

    # billing_address
    $self->aggregate( billing_address => 'entity-address', $self->{billing_address} || {} );

    # Aggregate items
    $self->aggregate_collection( 'items', 'entity-cart-item', $self->param('items') || [] );

    # Aggregate shipments
    my $param = $self->param('shipments') || [ {} ];
    push @{$param}, {} unless @{$param};    # NOTE: At the time of "$param eq []"
    $self->aggregate_collection( 'shipments', 'entity-shipment', $param );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Entity::Cart

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Entity::Cart->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-cart')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Entity::Cart> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Entity::Cart> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
