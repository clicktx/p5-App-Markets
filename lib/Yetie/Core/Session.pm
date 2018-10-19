package Yetie::Core::Session;
use Mojo::Base 'Mojolicious::Plugin';
use Yetie::Core::Session::ServerSession;
use Yetie::Core::Session::Store::Dbic;

sub register {
    my ( $self, $app, $args ) = @_;
    $args ||= {};

    my $stash_key = delete $args->{stash_key} || 'yetie.server_session';
    my $init = delete $args->{init};

    # Helpers
    $app->helper( cart_session   => sub { shift->stash($stash_key)->{cart_session} } );
    $app->helper( server_session => sub { shift->stash($stash_key) } );

    # Hooks
    $app->hook(
        before_dispatch => sub {
            my $c = shift;

            say "hook! before_dispatch from plugin session";    # debug
            my $session =
              Yetie::Core::Session::ServerSession->new( %$args,
                store => Yetie::Core::Session::Store::Dbic->new( schema => $app->schema ), );
            $session->tx( $c->tx );
            $init->( $c, $session ) if $init;
            $c->stash( $stash_key => $session, );
            say "   ... set stash: $stash_key => session object";    # debug
        }
    );
    $app->hook(
        before_routes => sub {
            my $c = shift;

            say "hook! before_routes from plugin session";           # debug
            return if $c->stash('mojo.static');

            # Dynamic route only
            say "   ... This route is dynamic";                      # debug
            my $session = $c->stash($stash_key);
            $session->load;

            # Create session or extend expires
            if ( $session->sid ) {
                say "   ... ented session expires time.";            # debug
                $session->extend_expires;
            }
            else {
                _create_session( $c, $session );
            }
        }
    );
}

sub _create_session {
    my ( $c, $session ) = @_;
    my $landing_page_on_cookie = $c->cookie_session('landing_page');

    # cookieに対応している場合のみセッション生成する
    # cookieが無いときはlanding pageのurlを保存
    if ($landing_page_on_cookie) {
        say "   ... created new session.";    # debug
        $session->data( landing_page => $landing_page_on_cookie, );
        $session->create;
    }
    else {
        say "   ... created cookie landing_page.";    # debug
        my $landing_page = $c->req->url->to_string;
        $c->cookie_session( landing_page => $landing_page );
    }
}

1;
__END__

=head1 NAME

Yetie::Core::Session - forked from Mojolicious::Plugin::Session

=head1 SYNOPSIS

    # Mojolicious::Lite
    plugin session =>
        {
            stash_key       => 'yetie.session',
            store           => 'dbi',
            expires_delta   => 5
        };

    # Mojolicious
    $self->plugin(
        session => {
            stash_key       => 'yetie.session',
            store           => 'dbi',
            expires_delta   => 5
        }
    );

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<stash_key>

    Yetie::Core::Session::ServerSession instance will be saved in stash using this key.

=head1 HELPERS

=head2 C<cart_session>

    my $cart_session = $c->cart_session;

    # Longer version
    my $cart_session = $c->server_session->cart_session;

Return L<Yetie::Core::Session::CartSession> object.

=head2 C<server_session>

    my $server_session = $c->server_session;

Return L<Yetie::Core::Session::ServerSession> object.

=head1 SEE ALSO

L<Yetie::Core::Session::ServerSession>

L<Yetie::Core::Session::CartSession>

L<Mojolicious::Plugin::Session>

L<MojoX::Session>

L<Mojolicious>

=cut
