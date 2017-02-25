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
    '/test/items' => sub {
        my $c = shift;

        subtest 'items' => sub {
            my $items = $c->service('cart')->items;
            is ref $items, 'Mojo::Collection', 'right object';
            is_deeply $items->to_array, [ [] ], 'right items';
        };

        $c->render( text => 1 );
    }
);

$r->post(
    '/test/add_item' => sub {
        my $c = shift;

        subtest 'items' => sub {
            $c->service('cart')->add_item;
            my $items = $c->service('cart')->items;
            is_deeply $items->to_array, [ [ { product_id => 1, quantity => 1 } ] ],
              'right add item';
        };

        subtest 'data' => sub {
            is_deeply $c->service('cart')->data,
              { items => [ [ { product_id => 1, quantity => 1 } ] ] };
        };

        # for merge_cart test
        my $cart_id = $c->server_session->cart_id('123456');
        is $cart_id, '123456';

        $c->render( text => 1 );
    }
);

$r->get(
    '/test/merge_cart' => sub {
        my $c = shift;

        subtest 'merge_cart' => sub {
            ok 1;
        };

        $c->render( text => 1 );
    }
);

# Requests
$t->get_ok('/test/create_session');
$t->get_ok('/test/items')->status_is(200);

my $params = { product_id => 1, quantity => 1 };
$t->post_ok( '/test/add_item', form => $params )->status_is(200);
$t->get_ok('/test/merge_cart')->status_is(200);

done_testing();
