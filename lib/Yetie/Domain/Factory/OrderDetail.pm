package Yetie::Domain::Factory::OrderDetail;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    my $billing_address = $self->factory('entity-address')->create( $self->param('billing_address') || {} );
    $self->param( billing_address => $billing_address );

    my $shipping_address = $self->factory('entity-address')->create( $self->param('shipping_address') || {} );
    $self->param( shipping_address => $shipping_address );

    my $items = $self->factory('entity-order-items')->create( { item_list => $self->param('items') || [] } );
    $self->param( items => $items );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::OrderDetail

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::OrderDetail->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-order_detail')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::OrderDetail> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::OrderDetail> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
