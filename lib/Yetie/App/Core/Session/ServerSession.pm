package Yetie::App::Core::Session::ServerSession;

use Mojo::Base qw/MojoX::Session/;
use Yetie::App::Core::Session::CartSession;
use Yetie::Util qw();

has cart_session => sub { Yetie::App::Core::Session::CartSession->new(shift) };
has cart         => sub { shift->cart_session };

has _cookie_expires      => 0;
has cookie_expires_delta => 3600 * 24 * 365;
has cookie_token_length  => 40;

sub cart_id { shift->data('cart_id') }

sub customer_id {
    my ( $self, $id ) = @_;
    return $id ? $self->data( customer_id => $id ) : $self->data('customer_id') // '';
}

sub cookie_expires {
    my $self = shift;
    my ($val) = @_;

    if ( defined $val ) {
        $self->_cookie_expires($val);
        $self->_is_flushed(0);
    }

    return $self->_cookie_expires;
}

sub extend_expires {
    my $self = shift;

    $self->SUPER::extend_expires(@_);
    $self->cookie_expires( time + $self->cookie_expires_delta );

    if ( $self->transport ) {
        $self->transport->tx( $self->tx );
        $self->transport->set( $self->sid, $self->cookie_expires );
    }
}

sub flush {
    my $self = shift;

    my $result = $self->SUPER::flush(@_);
    $self->cart->is_modified(0);
    return $result;
}

sub generate_cookie_token {
    my $self = shift;
    Yetie::Util::generate_token( length => $self->cookie_token_length, alphabet => [ 'a' .. 'z', '0' .. '9' ] );
}

sub new {
    my $class = shift;
    my %args  = @_;

    my $domain   = delete $args{domain}   // '';
    my $path     = delete $args{path}     // '/';
    my $httponly = delete $args{httponly} // 0;
    my $secure   = delete $args{secure}   // 0;

    my $self = $class->SUPER::new(%args);

    my $transport = $self->transport;
    $transport->domain($domain);
    $transport->path($path);
    $transport->httponly($httponly);
    $transport->secure($secure);
    return $self;
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

sub remove_session {
    my $self = shift;

    # 2重ログアウト対策
    $self->_is_flushed(1);
    return 0 unless $self->_is_stored;

    $self->expire;
    $self->_is_flushed(0);
    $self->flush;
    return 1;
}

sub staff_id {
    my ( $self, $id ) = @_;
    return $id ? $self->data( staff_id => $id ) : $self->data('staff_id') // '';
}

# Override method MojoX::Session::create
##################################
sub create {
    my ( $self, $args ) = ( shift, shift || {} );

    # Session
    my $sid = $self->SUPER::create(@_);

    # cookie
    # NOTE: override expires for cookie
    $self->cookie_expires( time + $self->cookie_expires_delta );
    if ( $self->transport ) {
        $self->transport->tx( $self->tx );
        $self->transport->set( $self->sid, $self->cookie_expires );
    }

    # cart
    my $cart_id = $args->{cart_id} || $self->generate_cookie_token;
    my $cart = {
        data         => {},
        _is_modified => 0,
    };
    $self->data( cart_id => $cart_id, cart => $cart );

    return $sid;
}

sub load {
    my $self = shift;
    my $sid  = $self->SUPER::load(@_);

    $self->data( cart => {} ) unless $self->data('cart');
    return $sid;
}

1;
__END__

=for stopwords sid

=head1 NAME

Yetie::App::Core::Session::ServerSession - based MojoX::Session

=head1 SYNOPSIS

    Yetie::App::Core::Session::ServerSession->new(
        # MojoX::Session option
        tx        => $tx,
        store     => MojoX::Session::Store::Dbi->new( dbh => $dbh ),
        transport => MojoX::Session::Transport::Cookie->new,
        ip_match  => 1

        # Constructor options
        name      => 'sid',
        domain    => '',
        path      => '/',
        httponly  => 1,
        secure    => 0,
    );

=head1 DESCRIPTION

=head1 OPTIONS

Constructor C<new> takes some options as hash or hashref.

=head2 C<name>

default: sid

=head2 C<domain>

default: empty string

=head2 C<path>

default: /

=head2 C<httponly>

default: 1

=head2 C<secure>

default: 0

=head1 ATTRIBUTES

=head2 C<cart_session>

    my $cart_session = $session->cart_session;

Returns new L<Yetie::App::Core::Session::CartSession> object.

=head2 C<cart>

    my $cart_session = $session->cart;

Alias for L</cart_session>

=head2 C<cookie_expires_delta>

    my $delta = $session->cookie_expires_delta;

=head2 C<cookie_token_length>

Default: 40

See L</generate_cookie_token>

=head1 METHODS

L<Yetie::App::Core::Session::ServerSession> inherits all methods from L<MojoX::Session> and implements
the following new ones.

=head2 C<cart_id>

    my $cart_id = $session->cart_id;

Get cart id.

=head2 C<cookie_expires>

    my $expires = $session->cookie_expires;
    $session->cookie_expires(1234567890);

Get/Set cookie expire time.

=head2 C<create>

    my $sid = $session->create;

    # Specify cart id
    my $sid = $session->create( { cart_id => 111 } );

This method override L<MojoX::Session/create>.

=head2 C<customer_id>

    my $customer_id = $session->customer_id;
    $session->customer_id('xxxxxxxxxx');

Get/Set customer id.

=head2 C<extend_expires>

This method override L<MojoX::Session/extend_expires>.

=head2 C<flush>

    $session->flush;

This method override L<MojoX::Session/flush>.
Stored session data.

=head2 C<generate_cookie_token>

    my $token = $session->genarate_token;

=head2 C<load>

    my $sid = $session->load;

=head2 C<regenerate_sid>

    my $sid = $session->regenerate_sid;

=head2 C<remove_cart>

    $session->remove_cart($cart_id);

Remove cart from DB.

=head2 C<remove_session>

    my $bool = $session->remove_session;

Remove session.
Return C<boolean> value.

=head2 C<staff_id>

    my $staff_id = $session->staff_id;
    $session->staff_id('xxxxxxxxxx');

Get/Set staff id.

=head1 SEE ALSO

L<Yetie::App::Core::Session::CartSession>, L<MojoX::Session>, L<Mojolicious>

=cut
