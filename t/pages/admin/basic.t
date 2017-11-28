package t::pages::admin::basic;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Mojo;

sub t01_not_logedin_request : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->ua->max_redirects(0);

    my $paths = $self->make_paths( $self->app->routes->find('RN_admin_bridge')->children, {} );
    foreach my $path ( @{$paths} ) {
        $t->get_ok($path)->status_is( 302, 'right redirect' );
    }
}

sub t02_admin_login_process : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->ua->max_redirects(0);

    $t->get_ok('/admin/login');
    my $csrf_token = $t->tx->res->dom->at('input[name="csrf_token"]')->{value};
    my $sid        = t::Util::get_sid($t);
    ok $sid, 'right sid';

    $t->get_ok('/admin/orders')->status_is( 302, 'right redirect' );
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, login_id => 'staff' } )->status_is(200)
      ->text_like( 'title' => qr/login/i, 'failure login' );

    $t->ua->max_redirects(1);
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, login_id => 'staff', password => '12345678' } )
      ->status_is(200)->text_like( 'title' => qr/orders/i, 'right redirect after login' );

    my $sid_loged_in = t::Util::get_sid($t);
    isnt $sid, $sid_loged_in, 'right regenerate sid';
}

__PACKAGE__->runtests;
