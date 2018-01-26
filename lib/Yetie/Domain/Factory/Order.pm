package Yetie::Domain::Factory::Order;
use Mojo::Base 'Yetie::Domain::Factory';

sub cook {
    my $self = shift;

    my $billing_address = $self->factory('entity-address')->create( $self->param('billing_address') || {} );
    $self->param( billing_address => $billing_address );

    my $shipping_address = $self->factory('entity-address')->create( $self->param('shipping_address') || {} );
    $self->param( shipping_address => $shipping_address );
}

1;
__END__

=head1 NAME

Yetie::Domain::Factory::Order

=head1 SYNOPSIS

    my $entity = Yetie::Domain::Factory::Order->new( %args )->create;

    # In controller
    my $entity = $c->factory('entity-order')->create(%args);

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Factory::Order> inherits all attributes from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 METHODS

L<Yetie::Domain::Factory::Order> inherits all methods from L<Yetie::Domain::Factory> and implements
the following new ones.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Yetie::Domain::Factory>
