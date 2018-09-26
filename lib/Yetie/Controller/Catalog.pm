package Yetie::Controller::Catalog;
use Mojo::Base 'Yetie::Controller';

sub init {
    my $c = shift;

    my $cart   = $c->server_session->cart;
    my $data   = $cart->data;
    my $entity = $c->factory('entity-cart')->construct( cart_id => $cart->cart_id, %{$data} );
    $c->stash( 'yetie.cart' => $entity );

    $c->SUPER::init();
    return $c;
}

sub finalize {
    my $c = shift;

    # cartが変更されていた場合はセッションカートのデータを変更
    $c->cart_session->data( $c->cart->to_data ) if $c->cart->is_modified;

    $c->SUPER::finalize();
    return $c;
}

1;
__END__

=head1 NAME

Yetie::Controller::Catalog - Controller base class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Controller::Catalog> inherits all attributes from L<Yetie::Controller> and
implements the following new ones.

=head2 C<cart>

    my $cart = $c->cart;
    $c->cart($entity_cart);

Get/Set entity cart object for stash `yetie.cart`

=head1 METHODS

L<Yetie::Controller::Catalog> inherits all methods from L<Yetie::Controller> and
implements the following new ones.

=head2 C<is_logged_in>

=head1 SEE ALSO

L<Yetie::Controller>

L<Mojolicious::Controller>

L<Mojolicious>

=cut
