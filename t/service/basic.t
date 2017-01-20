use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Scalar::Util ();

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# routes
my $r = $app->routes->namespaces( ['Markets::Controller'] );
$r->find('RN_category_name_base')->remove;
$r->get('/good')->to('test#good');
$r->get('/not_found')->to('test#not_found');
$r->get('/buged')->to('test#buged');

subtest 'Service Layer basic' => sub {
    $t->get_ok('/good')->json_is(
        {
            is_cached  => 0,
            service    => "Markets::Service::Test",
            app        => "App",
            controller => "Markets::Controller::Test",
            is_weak    => 1,
        }
    );
    $t->get_ok('/good')->json_is(
        {
            is_cached  => 1,
            service    => "Markets::Service::Test",
            app        => "App",
            controller => "Markets::Controller::Test",
            is_weak    => 1,
        }
    );
    $t->get_ok('/not_found')->status_is(500);
    $t->get_ok('/buged')->status_is(500);
};

done_testing();

package Markets::Controller::Test;
use Mojo::Base 'Markets::Controller::Catalog';

sub good {
    my $c         = shift;
    my $is_cached = $c->app->{service_class}{Test} ? 1 : 0;
    my $service   = $c->service('test');
    my $is_weak   = Scalar::Util::isweak $service->{controller} ? 1 : 0;

    return $c->render(
        json => {
            is_cached  => $is_cached,
            service    => ref $service,
            app        => ref $service->app,
            controller => ref $service->controller,
            is_weak    => $is_weak,
        }
    );
}

sub not_found {
    my $c       = shift;
    my $service = $c->service('test-not-fonnd');
}

sub buged {
    my $c       = shift;
    my $service = $c->service('buged');
}
