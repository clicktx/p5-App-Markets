use Mojolicious::Lite;
plugin 'Yetie::App::Core::DefaultHelpers';

any '/req' => sub {
    my $c = shift;
    $c->render( json => { req => $c->is_get_request } );
};

use t::Util;
use Test::More;
use Test::Mojo;

subtest 'cache' => sub {
    my $t = Test::Mojo->new('App');
    my $c = $t->app->build_controller;

    isa_ok $c->cache, 'Mojo::Cache';
    is $c->cache('foo'), undef, 'right no cache';

    $c->cache( 'foo' => 1 );
    is $c->cache('foo'), 1, 'right add cache';

    $c->cache( 'foo' => 5 );
    is $c->cache('foo'), 5, 'right replace cache';

    $c->cache( 'bar' => 7 );
    is $c->cache('bar'), 7, 'right other cache';
};

subtest 'is_get_request' => sub {
    my $t = Test::Mojo->new;
    $t->get_ok('/req')->json_is( { req => 1 } );
    $t->post_ok('/req')->json_is( { req => 0 } );
};

subtest 'is_logged_in' => sub {
    my $t = Test::Mojo->new('App');
    my $r = $t->app->routes->namespaces( ['Yetie::Controller'] );
    $r->get('/customer_loggedin')->to('customer#loggedin');
    $r->get('/staff_loggedin')->to('staff#loggedin');

    $t->get_ok('/customer_loggedin')->json_is( { is_logged_in => 0 } );
    $t->get_ok('/staff_loggedin')->json_is( { is_logged_in => 0 } );
};

done_testing();

package Yetie::Controller::Customer;
use Mojo::Base 'Yetie::Controller::Catalog';

sub loggedin {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}

package Yetie::Controller::Staff;
use Mojo::Base 'Yetie::Controller::Admin';

sub loggedin {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}

__END__
