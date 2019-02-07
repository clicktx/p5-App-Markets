package t::pages::catalog::login;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;
    $self->t->ua->max_redirects(0);
}

sub t00_login_process_with_password : Tests() {
    my $self = shift;
    my $t    = $self->t;

    # Access
    $t->get_ok('/account/wishlist');

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
