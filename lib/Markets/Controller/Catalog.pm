package Markets::Controller::Catalog;
use Mojo::Base 'Markets::Controller';

sub init {
    my $self = shift;

    my $cart_data = $self->cart_session->data;
    $cart_data->{cart_id} = $self->cart_session->cart_id;

    my $cart = $self->factory( 'entity-cart', $cart_data )->create;
    $self->stash( 'markets.entity.cart' => $cart );

    return $self;
}

sub finalize {
    my $self = shift;

    # cartが変更されていた場合はセッションカートのデータを変更
    $self->cart_session->data( $self->cart->to_data ) if $self->cart->is_modified;

    $self->SUPER::finalize(@_);
    return $self;
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

=head2 C<cart>

    my $cart = $c->cart;
    $c->cart($entity_cart);

Get/Set entity cart object for stash `markets.entity.cart`

=head1 METHODS

L<Markets::Controller::Catalog> inherits all methods from L<Markets::Controller> and
implements the following new ones.

=head2 C<is_logged_in>

=head1 SEE ALSO

L<Markets::Controller>

L<Mojolicious::Controller>

L<Mojolicious>

=cut
