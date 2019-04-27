package t::pages::catalog::auth::basic;

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

    $t->get_ok('/dropin')->status_is( 200, 'right dropin' )->content_like(qr/drop in/)
      ->element_exists_not('input[name=password]');

    $t->get_ok('/login')->status_is( 302, 'right redirect' );
    ok !$self->cookie_value('login_with_password'), 'right toggle off';
    $t->get_ok('/login/toggle')->status_is(302);
    ok $self->cookie_value('login_with_password'), 'right toggle on';

    $t->get_ok('/login')->status_is( 200, 'right login with-password' )->content_like(qr/auth-login-password/)
      ->element_exists('input[name=password]');

    $self->customer_logged_in;
    $t->get_ok('/login')->status_is( 302, 'right after logged-in' );
}

__PACKAGE__->runtests;
