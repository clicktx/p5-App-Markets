package t::pages::catalog::autn::login_remember_me;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    # Add routes
    my $r = $self->app->routes;
    $r->get('/set_remember_me')->to(
        cb => sub {
            my $c     = shift;
            my $token = $c->service('authentication')->remember_token('c@example.org');
            $c->render( json => {} );
        }
    );
    $r->get('/check_logged_in')->to(
        cb => sub {
            my $c = shift;
            $c->render( json => { customer_id => $c->server_session->customer_id } );
        }
    );
    $self->t->ua->max_redirects(0);
}

sub t00_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/account/wishlist')->get_ok('/login/remember-me')->status_is(302)
      ->header_is( Location => '/account/wishlist' );

    # FIXME: can not get a token(cookie path) ;(
    # $self->t->ua->max_redirects(3);
    # $t->get_ok('/set_remember_me')->status_is(200);
    # $t->get_ok('/account/wishlist')->status_is(200);
    # $t->get_ok('/check_logged_in')->json_is( { customer_id => 111 } );
}

__PACKAGE__->runtests;
