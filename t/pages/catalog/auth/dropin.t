package t::pages::catalog::auth::dropin;

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

    # Not registered
    my $post_data = {
        csrf_token => $self->csrf_token,
        email      => 'not-member-dropin@example.org',
    };
    $t->post_ok( '/dropin', form => $post_data )->status_is( 302, 'right not registered' )
      ->header_is( location => '/email/sent-magic-link' );

    # register request
    $post_data = {
        csrf_token => $self->csrf_token,
        email      => 'a@example.org',
    };
    $t->post_ok( '/dropin', form => $post_data )->status_is( 302, 'right token request' )
      ->header_is( location => '/email/sent-magic-link' );

    # magic-link
    $t->get_ok('/magic-link/foo-bar-baz')->status_is( 400, 'right illegal token' );
}

sub t02_magic_link : Tests() {
    my $self = shift;

    my $t  = $self->t;
    my $rs = $t->app->resultset('AuthenticationRequest');

    # signup
    my $token = $rs->find_last_by_email('not-member-dropin@example.org')->token;
    $t->get_ok("/magic-link/$token")->status_is( 302, 'right signup' );
    $t->get_ok("/logout");

    # login
    $token = $rs->find_last_by_email('a@example.org')->token;
    $t->get_ok("/magic-link/$token")->status_is( 302, 'right login' );
    $t->get_ok("/logout");
}

__PACKAGE__->runtests;
