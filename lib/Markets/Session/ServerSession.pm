package Markets::Session::ServerSession;

use Mojo::Base qw/MojoX::Session/;
use Markets::Session::CartSession;
use Markets::Util qw/generate_token/;

has cart_id => sub { shift->data('cart_id') };
has cart_session => sub { Markets::Session::CartSession->new( session => shift ) };

sub create {
    my $self = shift;
    my $sid  = $self->SUPER::create(@_);

    my $cart = {
        id           => generate_token( length => 40 ),
        data         => {},
        _is_modified => 0,
    };

    $self->data( cart => $cart );
    return $sid;
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
    $self->SUPER::_generate_sid;

    if ( $self->transport ) {
        $self->transport->tx( $self->tx );
        $self->transport->set( $self->sid, $self->expires );
    }

    $self->_is_flushed(0);
    $self->store->update_sid( $original_sid, $self->sid );

    return $self->sid;
}

sub _generate_sid {
    my $self = shift;
    $self->SUPER::_generate_sid;

    return if $self->data('cart_id');
    $self->data( cart_id => generate_token( length => 40 ) );
}

1;
__END__

=head1 NAME

Markets::Session::ServerSession - based MojoX::Session

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 METHODS

=head2 C<cart_session>

    my $cart_session = $session->cart_session;

Returns new L<Markets::Session::CartSession> object.

=head2 C<cart_id>

    my $cart_id = $session->cart_id;

Returns cart id.

=head2 C<regenerate_sid>

    my $sid = $session->regenerate_sid;

=head1 SEE ALSO

L<MojoX::Session>

L<Mojolicious>

=cut
