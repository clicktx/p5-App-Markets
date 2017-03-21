use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Markets::Domain::Factory::Entity::Cart';
ok $app->factory(
    'entity-cart',
    {
        cart_id   => '',
        cart_data => { items => [ [ {} ] ] }
    }
  ),
  'items data only';

my $cart;
my $cart_data = {
    shipments => [ { address => 'Tokyo' }, { address => 'Osaka' } ],
    items => [ [ { product_id => 1, quantity => 1 } ], [ { product_id => 2, quantity => 2 } ] ],
};

$cart = $app->factory(
    'entity-cart',
    {
        cart_id   => '12345',
        cart_data => $cart_data,
    }
);
isa_ok $cart, 'Markets::Domain::Entity::Cart';

subtest 'attributes' => sub {
    is $cart->cart_id,       '12345',            'right cart_id';
    isa_ok $cart->shipments, 'Mojo::Collection', 'right shipments';
};

subtest 'methods' => sub {
    is $cart->id, '12345', 'right entity id';
    is_deeply $cart->to_hash, $cart_data, 'right data structure';
    is $cart->total_item_count, 3, 'right total item count';

    my $cart2 = $app->factory(
        'entity-cart',
        {
            cart_id   => '54321',
            cart_data => $cart_data,
        }
    );
    is $cart->is_equal($cart),  1, 'right equal entity';
    is $cart->is_equal($cart2), 0, 'right not equal entity';
};

done_testing();
