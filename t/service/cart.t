use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $r = $app->routes;
$r->find('RN_category_name_base')->remove;    # Hack for name base category
$r->any('/:controller/:action')->to();

# Requests
$t->get_ok('/test/create_session');
$t->get_ok('/test/items')->status_is(200);
my $csrf_token = $t->tx->res->content->get_body_chunk;
my $params = { product_id => 1, quantity => 1, csrf_token => $csrf_token };
$t->post_ok( '/test/add_item', form => $params )->status_is(200);
$t->get_ok('/test/merge_cart')->status_is(200);
$t->get_ok('/test/clear_cart')->status_is(200);

done_testing();

{

    package Markets::Controller::Catalog::Test;
    use Mojo::Base 'Markets::Controller::Catalog';
    use Test::More;

    sub create_session { shift->render( text => 1 ) }

    sub items {
        my $c = shift;

        # subtest 'items' => sub {
        #     my $items = $c->service('cart')->items;
        #     is ref $items, 'Mojo::Collection', 'right object';
        #     is_deeply $items->to_array, [], 'right items';
        # };
        # is $c->service('cart')->has_items, 0, 'right false';

        $c->render( text => $c->csrf_token );
    }

    sub add_item {
        my $c = shift;

        subtest 'items' => sub {
            my $result = $c->service('cart')->add_item;
            is_deeply $result->{items}, [ { product_id => 1, quantity => 1 } ], 'right add cart';

            # my $items = $c->service('cart')->items;
            # isa_ok $items->first, 'Markets::Domain::Entity::Item', 'right add item';
            # is_deeply $items->first->to_hash, { product_id => 1, quantity => 1 }, 'right detail';
        };

        subtest 'data' => sub {
            is_deeply $c->service('cart')->cart_session_data,
              { items => [ { product_id => 1, quantity => 1 } ], shipments => [] };
        };

        # is $c->service('cart')->has_items, 1, 'right true';

        # for merge_cart test
        my $cart_id = $c->server_session->cart_id('123456');
        is $cart_id, '123456';

        $c->render( text => 1 );
    }

    sub merge_cart {
        my $c = shift;

        # subtest 'merge_cart' => sub {
        #     ok 1;
        # };

        $c->render( text => 1 );
    }

    sub clear_cart {
        my $c = shift;

        # my $cart = $c->service('cart');
        # $cart->clear;
        #
        # subtest 'clear_cart' => sub {
        #     is_deeply $cart->data, {}, 'right clear cart';
        # };
        #
        # is $c->service('cart')->has_items, 0, 'right false';

        $c->render( text => 1 );
    }

    1;
}
