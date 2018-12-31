package t::pages::catalog::login;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

my $login_email = 'a@example.org';

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t00_login : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/login')->status_is( 302, 'right login magic-link' );

    $t->ua->cookie_jar->add(
        Mojo::Cookie::Response->new(
            name  => 'login_with_password',
            value => 1,
        )
    );
    $t->get_ok('/login')->status_is( 302, 'right login with-password' );

    $self->customer_loged_in;
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
      ->header_is( location => '/signup/email-sended' );

    $post_data = {
        csrf_token => $self->csrf_token,
        email      => $login_email,
    };
    $t->post_ok( '/login/magic-link', form => $post_data )->status_is( 302, 'right token request' )
      ->header_is( location => '/login/email-sended' );
}

sub t02_magic_link_callback : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $token =
      $t->app->resultset('AuthorizationRequest')->search( {}, { order_by => 'id DESC' } )->first->token;

    $t->get_ok("/login/token/foo-bar-baz")->status_is( 400, 'right illegal token' );
    $t->get_ok("/login/token/$token")->status_is( 302, 'right login' );
}

sub t03_login_process_with_password : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # logout
    $t->get_ok('/logout')->status_is(200);

    my $sid = t::Util::get_sid($t);
    ok $sid, 'right sid';

    # login
    my $tx         = $t->tx;
    my $csrf_token = $self->csrf_token;

    # not found customer
    $t->post_ok( '/login/with-password',
        form => { csrf_token => $csrf_token, email => 'xx@xxxx.xxx', password => '12345678' } )
      ->status_is( 401, 'not found customer' );

    # password failure
    $t->post_ok( '/login/with-password',
        form => { csrf_token => $csrf_token, email => 'c@example.org', password => '11223344' } )
      ->status_is( 401, 'password failure' );

    # accept and redirect to wishlist?
    $t->get_ok('/account/wishlist');
    $t->post_ok( '/login/with-password',
        form => { csrf_token => $csrf_token, email => 'c@example.org', password => '12345678' } )
      ->status_is( 302, 'right accepr to redirect' )
      ->header_like( location => qr/wishlist/, 'right location after redirect' );

    my $sid_loged_in = t::Util::get_sid($t);
    isnt $sid, $sid_loged_in, 'right regenerate sid';

    # logout
    $t->get_ok('/logout')->status_is(200);
    $t->get_ok('/account/home')->status_is(302);
    my $sid_new_session = t::Util::get_sid($t);
    isnt $sid_loged_in, $sid_new_session, 'right new sid';
}

__PACKAGE__->runtests;
