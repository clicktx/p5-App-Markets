use Mojolicious::Lite;
plugin 'Yetie::App::Core::DefaultHelpers';

any '/continue_none' => sub {
    my $c = shift;
    return $c->redirect_to('/continue_redirect');
};
any '/continue_foobar' => sub {
    my $c = shift;
    $c->continue_url('foobar');
    return $c->redirect_to('/continue_redirect');
};
any '/continue_redirect' => sub {
    my $c = shift;
    return $c->render( json => { continue_url => $c->continue_url } );
};

any '/req' => sub {
    my $c = shift;
    return $c->render( json => { req => $c->is_get_request } );
};

any '/prg' => sub {
    my $c = shift;
    return $c->prg_to('/');
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

subtest 'continue_url' => sub {
    my $t = Test::Mojo->new;
    $t->ua->max_redirects(1);
    $t->get_ok('/continue_none')->json_is( { continue_url => 'rn.home' } );
    $t->get_ok('/continue_foobar')->json_is( { continue_url => 'foobar' } );
};

subtest 'is_admin_route' => sub {
    my $t = Test::Mojo->new('App');
    my $r = $t->app->routes->namespaces( ['Yetie::Controller'] );
    $r->get('/customer_route')->to('customer#route');
    $r->get('/staff_route')->to('staff#route');

    $t->get_ok('/customer_route')->json_is( { route => 0 } );
    $t->get_ok('/staff_route')->json_is( { route => 1 } );
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

subtest 'prg_to' => sub {
    my $t = Test::Mojo->new;
    $t->get_ok('/prg')->status_is(303);
    $t->post_ok('/prg')->status_is(303);
};

done_testing();

package Yetie::Controller::Customer;
use Mojo::Base 'Yetie::Controller::Catalog';

sub loggedin {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}

sub route {
    my $c = shift;
    return $c->render( json => { route => $c->is_admin_route } );
}

package Yetie::Controller::Staff;
use Mojo::Base 'Yetie::Controller::Admin';

sub loggedin {
    my $c = shift;
    return $c->render( json => { is_logged_in => $c->is_logged_in } );
}

sub route {
    my $c = shift;
    return $c->render( json => { route => $c->is_admin_route } );
}

__END__
