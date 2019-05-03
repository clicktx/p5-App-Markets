package t::pages::catalog::autn::login_remember_me;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    # Add routes
    # my $r = $self->app->routes;
    # $r->get('/set_remember_me')->to(
    #     cb => sub {
    #         my $c     = shift;
    #         my $token = $c->service('authentication')->remember_token('c@example.org');
    #         $c->redirect_to('/');
    #     }
    # );
    # $r->get('/check_logged_in')->to(
    #     cb => sub {
    #         my $c = shift;
    #         $c->render( json => { customer_id => $c->server_session->customer_id } );
    #     }
    # );
    $self->t->ua->max_redirects(0);
}

sub t00_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/')->get_ok('/account/wishlist')->status_is(302)->header_is( Location => '/login' );
    $t->get_ok('/login/remember-me')->status_is(302)->header_is( Location => '/account/wishlist' );

    # my $session = t::Util::server_session( $self->app );
    # $session->tx( $t->tx );
    # $session->load;
    # ok !$session->is_customer_logged_in, 'right customer not logged in';
    # $t->get_ok('/check_logged_in')->json_is( { customer_id => undef } );

    # FIXME: can not get a token ;(
    # $t->get_ok('/set_remember_me')->status_is(302);
    # $t->get_ok('/login/remember-me')->status_is(302)->header_is( Location => '/' );
    # $session = t::Util::server_session( $self->app );
    # $session->tx( $t->tx );
    # $session->load;
    # ok $session->is_customer_logged_in, 'right customer logged in';
    # $t->get_ok('/check_logged_in')->json_is( { customer_id => 111 } );
}

__PACKAGE__->runtests;
