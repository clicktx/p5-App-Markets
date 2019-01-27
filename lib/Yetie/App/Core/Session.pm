package Yetie::App::Core::Session;
use Mojo::Base 'Mojolicious::Plugin';
use Yetie::App::Core::Session::ServerSession;
use Yetie::App::Core::Session::Store::Dbic;

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
              Yetie::App::Core::Session::ServerSession->new( %$args,
                store => Yetie::App::Core::Session::Store::Dbic->new( schema => $app->schema ), );
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
            if   ( !$session->is_expired ) { $session->extend_expires }
            else                           { _create_session( $c, $session ) }

            # Cookie check
            $c->cookie( cookie_check => 1, { expires => time + $c->pref('cookie_expires_long') } );
        }
    );
}

# NOTE: cookieに対応している場合のみセッション生成する
sub _create_session {
    my ( $c, $session ) = @_;

    # Landing page
    my $landing = $c->cookie_session('landing_page');
    $c->cookie_session( landing_page => $c->req->url->to_string ) unless $landing;

    # Cookie check
    my $cookie_check = $c->cookie('cookie_check');
    $c->cookie( cookie_check => 1, { expires => time + 60 * 60 * 24 * 365 } );
    return unless $cookie_check;

    # Create new server session
    $session->data( landing_page => $c->cookie_session('landing_page') );
    $session->create;
}

1;
__END__

=head1 NAME

Yetie::App::Core::Session - forked from Mojolicious::Plugin::Session

=head1 SYNOPSIS

    # Mojolicious::Lite
    plugin 'Yetie::App::Core::Session' =>
        {
            stash_key       => 'yetie.session',
            store           => 'dbi',
            expires_delta   => 5
        };

    # Mojolicious
    $self->plugin(
        'Yetie::App::Core::Session' => {
            stash_key       => 'yetie.session',
            store           => 'dbi',
            expires_delta   => 5
        }
    );

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head2 C<stash_key>

    Yetie::App::Core::Session::ServerSession instance will be saved in stash using this key.

=head1 HELPERS

=head2 C<cart_session>

    my $cart_session = $c->cart_session;

    # Longer version
    my $cart_session = $c->server_session->cart_session;

Return L<Yetie::App::Core::Session::CartSession> object.

=head2 C<server_session>

    my $server_session = $c->server_session;

Return L<Yetie::App::Core::Session::ServerSession> object.

=head1 SEE ALSO

L<Yetie::App::Core::Session::ServerSession>

L<Yetie::App::Core::Session::CartSession>

L<Mojolicious::Plugin::Session>

L<MojoX::Session>

L<Mojolicious>

=cut
