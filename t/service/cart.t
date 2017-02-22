use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $r = $app->routes;
$r->find('RN_category_name_base')->remove;    # Hack for name base category

$r->get( '/test/create_session' => sub { shift->render( text => 1 ) } );
$r->get(
    '/test/service-cart' => sub {
        my $c     = shift;
        my $items = $c->service('cart')->items;

        subtest 'items' => sub {
            is ref $items, 'Mojo::Collection', 'right object';
            is_deeply $items->to_array, [ [] ], 'right items';

            $c->service('cart')->add_item( { id => 1 } );
            $items = $c->service('cart')->items;
            is_deeply $items->to_array, [ [ { id => 1 } ] ], 'right add item';
        };

          $c->render( json => { items => $items } );
    }
);

$t->get_ok('/test/create_session');
$t->get_ok('/test/service-cart')->status_is(200);    #->json_is( {} );

done_testing();
