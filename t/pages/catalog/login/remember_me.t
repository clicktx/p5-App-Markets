package t::pages::catalog::login;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    # Add routes
    $self->app->routes->get('/login/remember-me')->to('login#remember_me');

    # $self->app->routes->get('/set_remember_me')->to(
    #     cb => sub {
    #         my $c     = shift;
    #         my $token = $c->service('customer')->remember_me_token('c@example.org');
    #         $c->render( json => { token => $token } );
    #     }
    # );

    $self->t->ua->max_redirects(0);
}

sub t00_remember_me : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/')->get_ok('/account/wishlist')->status_is(302);
    $t->get_ok('/login/remember-me')->status_is(302);
    my $session = t::Util::server_session( $self->app );
    $session->tx( $t->tx );
    $session->load;
    ok !$session->is_customer_logged_in, 'right customer not logged in';

    # FIXME: can not get a token ;(
    # $t->get_ok('/set_remember_me')->status_is(200);
    # $t->get_ok('/login/remember-me')->status_is(302);
    # $session = t::Util::server_session( $self->app );
    # $session->tx( $t->tx );
    # $session->load;
    # ok $session->is_customer_logged_in, 'right customer logged in';
}

__PACKAGE__->runtests;
