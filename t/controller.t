use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# routes
my $r = $app->routes->namespaces( ['Yetie::Controller'] );
$r->get('/customer')->to('customer#login');
$r->get('/staff')->to('staff#login');
$r->get('/buged')->to('buged#login');
$r->get('/request')->to('customer#request');

subtest 'is_get_request' => sub {
    $t->get_ok('/request')->json_is( { is_get_request => 1 } );
};

subtest 'is_logged_in' => sub {
    $t->get_ok('/customer')->json_is( { is_logged_in => 0 } );
    $t->get_ok('/staff')->json_is( { is_logged_in => 0 } );
    $t->get_ok('/buged')->json_is( { is_logged_in => undef } );
};

done_testing();

package Yetie::Controller::Customer;
use Mojo::Base 'Yetie::Controller::Catalog';

sub login {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}

sub request {
    my $c = shift;
    return $c->render( json => { is_get_request => $c->is_get_request } );
}

package Yetie::Controller::Staff;
use Mojo::Base 'Yetie::Controller::Admin';

sub login {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}

package Yetie::Controller::Buged;
use Mojo::Base 'Yetie::Controller';

sub login {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}
1;
