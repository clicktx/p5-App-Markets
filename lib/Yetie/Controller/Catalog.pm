package Yetie::Controller::Catalog;
use Mojo::Base 'Yetie::Controller';

sub init {
    my $self = shift;

    my $cart   = $self->server_session->cart;
    my $data   = $cart->data;
    my $entity = $self->factory('entity-cart')->create( cart_id => $cart->cart_id, %{$data} );
    $self->stash( 'yetie.entity.cart' => $entity );

    $self->SUPER::init();
    return $self;
}

sub finalize {
    my $self = shift;

    # cartが変更されていた場合はセッションカートのデータを変更
    $self->cart_session->data( $self->cart->to_data ) if $self->cart->is_modified;

    $self->SUPER::finalize();
    return $self;
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

Get/Set entity cart object for stash `yetie.entity.cart`

=head1 METHODS

L<Yetie::Controller::Catalog> inherits all methods from L<Yetie::Controller> and
implements the following new ones.

=head2 C<is_logged_in>

=head1 SEE ALSO

L<Yetie::Controller>

L<Mojolicious::Controller>

L<Mojolicious>

=cut
