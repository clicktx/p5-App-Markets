use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
$app->routes->any('/:controller/:action')->to();

# Requests
$t->get_ok('/test/get_csrf_token')->status_is(200);
my $csrf_token = $t->tx->res->content->get_body_chunk;
my $params = { product_id => 1, quantity => 1, csrf_token => $csrf_token };
$t->post_ok( '/test/add_item', form => $params )->status_is(200);
$t->get_ok('/test/find_customer_cart')->status_is(200);

done_testing();

{

    package Yetie::Controller::Catalog::Test;
    use Mojo::Base 'Yetie::Controller::Catalog';
    use Test::More;

    sub get_csrf_token {
        my $c = shift;
        $c->render( text => $c->csrf_token );
    }

    sub add_item {
        my $c = shift;

        subtest 'items' => sub {
            my $result = $c->service('cart')->add_item( { product_id => 1, quantity => 1 } );
            is_deeply $result->items->last->to_data,
              { product_id => 1, product_title => 'test product1', quantity => 1, price => '100.00' },
              'right add cart';
        };
        $c->render( text => 1 );
    }

    sub find_customer_cart {
        my $c = shift;

        my $customer_cart = $c->service('cart')->find_customer_cart('111');
        isa_ok $customer_cart, 'Yetie::Domain::Entity::Cart';
        $c->render( text => 1 );
    }

    1;
}
