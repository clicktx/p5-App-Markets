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

        subtest 'items, add_item' => sub {
            my $items = $c->service('cart')->items;
            is ref $items, 'Mojo::Collection', 'right object';
            is_deeply $items->to_array, [ [] ], 'right items';

            $c->service('cart')->add_item( { product_id => 1, quantiry => 1 } );
            $items = $c->service('cart')->items;
            is_deeply $items->to_array, [ [ { product_id => 1, quantiry => 1 } ] ],
              'right add item';

            $items = $c->service('cart')->items( [ [ {} ], [ {} ] ] );
            is ref $items, 'Mojo::Collection', 'right object';
            is_deeply $items->to_array, [ [ {} ], [ {} ] ], 'right items';
        };

        subtest 'data' => sub {
            is_deeply $c->service('cart')->data,
              { items => [ [ { product_id => 1, quantiry => 1 } ] ] };
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

$t->get_ok('/test/create_session');
$t->get_ok('/test/items')->status_is(200);
$t->get_ok('/test/merge_cart')->status_is(200);

# Test for private method
subtest 'merge items' => sub {
    my $items = [
        { product_id => 1, quantiry => 10 },
        { product_id => 3, quantiry => 10 },
        { product_id => 5, quantiry => 10 },
        { product_id => 7, quantiry => 10 },
    ];
    my $stored_items = [
        { product_id => 1, quantiry => 1 },
        { product_id => 2, quantiry => 1 },
        { product_id => 3, quantiry => 1 },
        { product_id => 4, quantiry => 1 },
    ];

    my $merged_items = Markets::Service::Cart::_merge_items( $items, $stored_items );
    is_deeply $merged_items,
      [
        { product_id => 2, quantiry => 1 },
        { product_id => 4, quantiry => 1 },
        { product_id => 1, quantiry => 10 },
        { product_id => 3, quantiry => 10 },
        { product_id => 5, quantiry => 10 },
        { product_id => 7, quantiry => 10 },
      ],
      'right merged';
};

done_testing();
