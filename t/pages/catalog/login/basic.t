package t::pages::catalog::login;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t00_basic : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/login')->status_is( 200, 'right login magic-link' )->content_like(qr/magic_link-email/)
      ->element_exists_not('input[name=password]');

    ok !$self->cookie_value('login_with_password'), 'right toggle off';
    $t->get_ok('/login/toggle')->status_is(302);
    ok $self->cookie_value('login_with_password'), 'right toggle on';

    $t->get_ok('/login')->status_is( 200, 'right login with-password' )->content_like(qr/account-login-password/)
      ->element_exists('input[name=password]');

    $self->customer_logged_in;
    $t->get_ok('/login')->status_is( 302, 'right after logged-in' );
}

sub t01_magic_link_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/login/magic-link')->status_is( 200, 'right request form' );

    # Not registered
    my $post_data = {
        csrf_token => $self->csrf_token,
        email      => 'foo-bar-baz@example.org',
    };
    $t->post_ok( '/login/magic-link', form => $post_data )->status_is( 302, 'right not registered' )
      ->header_is( location => '/signup/sent-email' );

    $post_data = {
        csrf_token => $self->csrf_token,
        email      => 'a@example.org',
    };
    $t->post_ok( '/login/magic-link', form => $post_data )->status_is( 302, 'right token request' )
      ->header_is( location => '/login/sent-email' );
}

sub t02_magic_link_callback : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $token =
      $t->app->resultset('AuthorizationRequest')->search( {}, { order_by => 'id DESC' } )->first->token;

    $t->get_ok("/login/token/foo-bar-baz")->status_is( 400, 'right illegal token' );
    $t->get_ok("/login/token/$token")->status_is( 302, 'right login' );
}

__PACKAGE__->runtests;
