package Yetie::Domain::Factory::Cart;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    # billing_address
    my $billing_address = $self->factory('entity-address')->create( $self->{billing_address} || {} );
    $self->param( billing_address => $billing_address );

    # Aggregate items
    $self->aggregate( 'items', 'entity-cart-item', $self->param('items') || [] );

    # Aggregate shipments
    my $param = $self->param('shipments') || [ {} ];
    push @{$param}, {} unless @{$param};    # NOTE: At the time of "$param eq []"
    $self->aggregate( 'shipments', 'entity-shipment', $param );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Cart

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Cart->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-cart')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Cart> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Cart> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
