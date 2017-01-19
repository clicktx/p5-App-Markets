use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# routes
my $r = $app->routes->namespaces( ['Markets::Controller'] );
$r->find('RN_category_name_base')->remove;
$r->get('/good')->to('test#good');
$r->get('/not_found')->to('test#not_found');
$r->get('/buged')->to('test#buged');

subtest 'Service Layer basic' => sub {
    $t->get_ok('/good')->content_is("App::Service::Test");
    $t->get_ok('/not_found')->status_is(500);
    $t->get_ok('/buged')->status_is(500);
};

done_testing();

package Markets::Controller::Test;
use Mojo::Base 'Markets::Controller::Catalog';

sub good {
    my $c       = shift;
    my $service = $c->service('test');
    return $c->render( text => ref $service );
}

sub not_found {
    my $c       = shift;
    my $service = $c->service('test-not-fonnd');
}

sub buged {
    my $c       = shift;
    my $service = $c->service('buged');
}
