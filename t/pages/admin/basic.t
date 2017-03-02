use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _make_path {
    my @paths;
    my $routes = shift;
    foreach my $r ( @{$routes} ) {
        if ( $r->is_endpoint ) { push @paths, $r->render }
        else                   { _make_path( $r->children ) }
    }
    return \@paths;
}

subtest 'requred authrization pages' => sub {
    my $paths = _make_path( $app->routes->find('RN_admin_bridge')->children );
    $t->get_ok($_)->status_is( 302, 'right redirect' ) for @{$paths};
};

subtest 'admin login process' => sub {
    $t->ua->max_redirects(0);
    $t->get_ok('/admin/login');
    my $csrf_token = $t->tx->res->dom->at('input[name="csrf_token"]')->{value};
    my $sid        = t::Util::get_sid($t);
    ok $sid, 'right sid';

    $t->get_ok('/admin/orders')->status_is( 302, 'right redirect' );
    $t->post_ok( '/admin/login', form => { csrf_token => $csrf_token, customer_id => 'default' } )
      ->status_is(200)->text_like( 'title' => qr/login/i, 'failure login' );

    $t->ua->max_redirects(1);
    $t->post_ok( '/admin/login',
        form => { csrf_token => $csrf_token, customer_id => 'default', password => 'pass' } )
      ->status_is(200)->text_like( 'title' => qr/orders/i, 'right redirect after login' );

    my $sid_loged_in = t::Util::get_sid($t);
    isnt $sid, $sid_loged_in, 'right regenerate sid';
};

done_testing();
