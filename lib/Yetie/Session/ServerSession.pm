package Yetie::Session::ServerSession;

use Mojo::Base qw/MojoX::Session/;
use Yetie::Session::CartSession;
use Yetie::Util qw/generate_token/;

has cart_session => sub { Yetie::Session::CartSession->new(shift) };
has cart         => sub { shift->cart_session };

sub cart_id { shift->data('cart_id') }

sub customer_id {
    my ( $self, $id ) = @_;
    return $id ? $self->data( customer_id => $id ) : $self->data('customer_id');
}

sub flush {
    my $self = shift;

    my $result = $self->SUPER::flush(@_);
    $self->cart->is_modified(0);
    return $result;
}

sub regenerate_sid {
    my $self = shift;

    my $original_sid = $self->sid;
    $self->_generate_sid;
    return if !$self->store->update_sid( $original_sid, $self->sid );

    if ( $self->transport ) {
        $self->transport->tx( $self->tx );
        $self->transport->set( $self->sid, $self->expires );
    }
    return $self->sid;
}

sub remove_cart {
    my ( $self, $id ) = @_;
    return if !$id;

    return $self->store->delete_cart($id);
}

sub staff_id {
    my ( $self, $id ) = @_;
    return $id ? $self->data( staff_id => $id ) : $self->data('staff_id');
}

# Overwride method MojoX::Session
##################################
sub create {
    my ( $self, $args ) = ( shift, shift || {} );

    # New cart
    my $sid = $self->SUPER::create(@_);
    my $id =
      $args->{cart_id} ? $args->{cart_id} : generate_token( length => 40, alphabet => [ 'a' .. 'z', '0' .. '9' ] );
    my $cart = {
        data         => {},
        _is_modified => 0,
    };
    $self->data( cart_id => $id, cart => $cart );

    return $sid;
}

sub load {
    my $self = shift;
    my $sid  = $self->SUPER::load(@_);

    $self->data( cart => {} ) if !$self->data('cart');
    return $sid;
}

1;
__END__

=head1 NAME

Yetie::Session::ServerSession - based MojoX::Session

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<cart_session>

    my $cart_session = $session->cart_session;

Returns new L<Yetie::Session::CartSession> object.

=head2 C<cart>

    my $cart_session = $session->cart;

Alias for L</cart_session>

=head1 METHODS

L<Yetie::Session::ServerSession> inherits all methods from L<MojoX::Session> and implements
the following new ones.

=head2 C<cart_id>

    my $cart_id = $session->cart_id;

Get cart id.

=head2 C<create>

    my $sid = $session->create;

    # Specify cart id
    my $sid = $session->create( { cart_id => 111 } );

This method overrided L<MojoX::Session/create>.

=head2 C<customer_id>

    my $customer_id = $session->customer_id;
    $cart->customer_id('xxxxxxxxxx');

Get/Set customer id.

=head2 C<flush>

    $session->flush;

This method overrided L<MojoX::Session/flush>.
Stored session data.

=head2 C<regenerate_sid>

    my $sid = $session->regenerate_sid;

=head2 C<remove_cart>

    $session->remove_cart($cart_id);

Remove cart from DB.

=head2 C<staff_id>

    my $staff_id = $session->staff_id;
    $cart->staff_id('xxxxxxxxxx');

Get/Set staff id.

=head1 SEE ALSO

L<Yetie::Session::CartSession>

L<MojoX::Session>

L<Mojolicious>

=cut
