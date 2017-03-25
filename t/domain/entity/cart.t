use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $cart;
my $cart_data = {
    items => [
        { product_id => 1, quantity => 1 },
        { product_id => 2, quantity => 2 },
        { product_id => 3, quantity => 3 },
    ],
    shipments => [
        { address => 'Tokyo', items => [ { product_id => 4, quantity => 4 } ] },
        { address => 'Osaka', items => [ { product_id => 5, quantity => 5 } ] },
    ],
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
    is $cart->cart_id,     '12345', 'right cart_id';
    is $cart->is_modified, 0,       'right is_modified';

    isa_ok $cart->items, 'Mojo::Collection', 'right items';
    isa_ok $cart->items->first, 'Markets::Domain::Entity::Item', 'right items';

    isa_ok $cart->shipments, 'Mojo::Collection', 'right shipments';
    isa_ok $cart->shipments->first, 'Markets::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    is_deeply $cart->to_hash, $cart_data, 'right data structure';
    is $cart->id, '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->total_item_count, 15, 'right total item count';

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

subtest 'method add_item' => sub {
    $cart->add_item( Markets::Domain::Entity::Item->new( id => 1 ) );
    is $cart->is_modified, 1, 'right modified';
};

# method merge
# my $stored_cart_data = {
#     items => [
#         { product_id => 1, quantity => 1 },
#         { product_id => 4, quantity => 4 },
#         { product_id => 5, quantity => 5 },
#     ],
#     shipments => [],
# };
# my $stored_cart = $app->factory(
#     'entity-cart',
#     {
#         cart_id   => '99999',
#         cart_data => $stored_cart_data,
#     }
# );
#
# my $new_cart = $cart->merge();
#
# # is $new_cart->id, '', '';
#
# is_deeply $new_cart->to_hash, {
#     items => [
#         { product_id => 4, quantity => 4 },
#         { product_id => 5, quantity => 5 },
#         { product_id => 2, quantity => 2 },
#         { product_id => 3, quantity => 3 },
#     ],
#     shipments => [
#         { address => 'Tokyo', items => [ { product_id => 4, quantity => 4 } ] },
#         { address => 'Osaka', items => [ { product_id => 5, quantity => 5 } ] },
#
#     ],
#   },
#   'right merge data';
#
# is_deeply $new_cart->to_hash,
#   {
#     items => [
#         { product_id => 1, quantity => 1 },
#         { product_id => 4, quantity => 4 },
#         { product_id => 5, quantity => 5 },
#     ],
#     shipments => [],
#     asides    => {
#         items => [
#             { product_id => 1, quantity => 1 },
#             { product_id => 2, quantity => 2 },
#             { product_id => 3, quantity => 3 },
#         ],
#         shipments => [
#             { address => 'Tokyo', items => [ { product_id => 4, quantity => 4 } ] },
#             { address => 'Osaka', items => [ { product_id => 5, quantity => 5 } ] },
#         ],
#     },
#   },
#   'right merge data';
#
# use DDP;
# say $cart;
# say $new_cart;
# p $new_cart->to_hash;

done_testing();
