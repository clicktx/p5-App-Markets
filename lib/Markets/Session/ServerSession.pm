package Markets::Session::ServerSession;

use Mojo::Base qw/MojoX::Session/;
use Markets::Session::CartSession;
use Markets::Util qw/generate_token/;

has cart_session => sub { Markets::Session::CartSession->new(shift) };

sub cart_data {
    my ( $self, $id ) = @_;
    return $id ? $self->store->load_cart_data($id) : $self->cart_session->data;
}

sub cart_id {
    my ( $self, $id ) = @_;
    my $cart_id = $self->data('cart_id');
    return $cart_id unless $id;

    return unless $self->store->update_cart_id( $cart_id, $id );
    $self->data( cart_id => $id );
    return $id;
}

sub create {
    my $self = shift;
    my $sid  = $self->SUPER::create(@_);

    # New cart
    my $id = generate_token( length => 40 );
    my $cart = {
        data         => {},
        _is_modified => 0,
    };
    $self->data( cart_id => $id, cart => $cart );

    return $sid;
}

sub customer_id {
    my $self = shift;
    return @_ ? $self->data( customer_id => $_[0] ) : $self->data('customer_id');
}

sub load {
    my $self = shift;
    my $sid  = $self->SUPER::load(@_);

    $self->data( cart => {} ) unless $self->data('cart');
    return $sid;
}

sub regenerate_sid {
    my $self = shift;

    my $original_sid = $self->sid;
    $self->_generate_sid;
    return unless $self->store->update_sid( $original_sid, $self->sid );

    if ( $self->transport ) {
        $self->transport->tx( $self->tx );
        $self->transport->set( $self->sid, $self->expires );
    }
    return $self->sid;
}

sub remove_cart {
    my ( $self, $id ) = @_;
    return unless $id;

    return $self->store->delete_cart($id);
}

1;
__END__

=head1 NAME

Markets::Session::ServerSession - based MojoX::Session

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<cart_session>

    my $cart_session = $session->cart_session;

Returns new L<Markets::Session::CartSession> object.

=head1 METHODS

L<Markets::Session::ServerSession> inherits all methods from L<MojoX::Session> and implements
the following new ones.

=head2 C<cart_data>

    my $cart_data = $session->cart_data;
    my $cart_data = $session->cart_data($cart_id);

Return cart data.

=head2 C<cart_id>

    my $cart_id = $session->cart_id;
    $cart->cart_id('xxxxxxxxxx');

Get/Set cart id.

=head2 C<regenerate_sid>

    my $sid = $session->regenerate_sid;

=head2 C<remove_cart>

    $session->remove_cart($cart_id);

Remove cart from DB.

=head1 SEE ALSO

L<Markets::Session::CartSession>

L<MojoX::Session>

L<Mojolicious>

=cut
