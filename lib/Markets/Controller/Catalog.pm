package Markets::Controller::Catalog;
use Mojo::Base 'Markets::Controller';

sub init {
    my $self = shift;

    my $cart_id   = $self->cart_session->cart_id;
    my $cart_data = $self->cart_session->data;
    my $cart      = $self->factory(
        'entity-cart',
        {
            cart_id   => $cart_id,
            cart_data => $cart_data,
        }
    );
    $self->stash( 'markets.entity.cart' => $cart, 'markets.entity.shipments' => $cart->shipments );
}

1;
__END__

=head1 NAME

Markets::Controller::Catalog - Controller base class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Controller::Catalog> inherits all attributes from L<Markets::Controller> and
implements the following new ones.

=head1 METHODS

L<Markets::Controller::Catalog> inherits all methods from L<Markets::Controller> and
implements the following new ones.

=head2 C<is_logged_in>

=head1 SEE ALSO

L<Markets::Controller>

L<Mojolicious::Controller>

L<Mojolicious>

=cut
