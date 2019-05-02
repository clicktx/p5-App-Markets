package t::pages::admin::basic;

use Mojo::Base 't::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_not_loggedin_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->ua->max_redirects(0);
}

sub t02_admin_login_process_with_password : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->ua->max_redirects(0);

    $t->get_ok('/admin/login');
    my $csrf_token = $t->tx->res->dom->at('input[name="csrf_token"]')->{value};
    my $sid        = t::Util::get_sid($t);
    ok $sid, 'right sid';

    $t->get_ok('/admin/orders')->status_is( 302, 'right redirect' );

    # not found staff
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, login_id => 'foobar', password => '12345678' } )
      ->status_is( 401, 'not found staff' )->text_like( 'title' => qr/login/i, 'failure login' );

    # password failure
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, login_id => 'staff', password => '1111' } )
      ->status_is( 401, 'password failure' )->text_like( 'title' => qr/login/i, 'failure login, old password' );
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, login_id => 'staff', password => '44556677' } )
      ->status_is( 401, 'password failure' )->text_like( 'title' => qr/login/i, 'failure login, bad password' );

    $t->ua->max_redirects(1);
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, login_id => 'staff', password => '12345678' } )
      ->status_is(200)->text_like( 'title' => qr/orders/i, 'right redirect after login' );

    my $sid_logged_in = t::Util::get_sid($t);
    isnt $sid, $sid_logged_in, 'right regenerate sid';
}

__PACKAGE__->runtests;
