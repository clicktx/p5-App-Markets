use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t         = Test::Mojo->new('App');
my $app       = $t->app;
my $cart_data = {
    items => [
        { product_id => 1, quantity => 1 },
        { product_id => 2, quantity => 2 },
        { product_id => 3, quantity => 3 },
    ],
    shipments => [
        { shipping_address => 'Tokyo', shipping_items => [ { product_id => 4, quantity => 4 } ] },
        {
            shipping_address => 'Osaka',
            shipping_items =>
              [ { product_id => 5, quantity => 5 }, { product_id => 6, quantity => 6 } ]
        },
    ],
};

sub _factory_cart {
    $app->factory(
        'entity-cart',
        {
            cart_id   => '12345',
            cart_data => $cart_data,
        }
    );
}

use_ok 'Markets::Domain::Entity::Item';

subtest 'basic' => sub {
    my $cart = $app->factory('entity-cart');
    isa_ok $cart, 'Markets::Domain::Entity';

    ok $cart->id;
    isa_ok $cart->items,     'Markets::Domain::Collection';
    isa_ok $cart->shipments, 'Markets::Domain::Collection';
};

subtest 'attributes' => sub {
    my $cart = _factory_cart;
    is $cart->cart_id, '12345', 'right cart_id';

    isa_ok $cart->items, 'Mojo::Collection', 'right items';
    isa_ok $cart->items->first, 'Markets::Domain::Entity::Item', 'right items';

    isa_ok $cart->shipments, 'Mojo::Collection', 'right shipments';
    isa_ok $cart->shipments->first, 'Markets::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    my $cart = _factory_cart;
    is_deeply $cart->to_hash, $cart_data, 'right data structure';
    is $cart->id, '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->total_item_count, 6,  'right total item count';
    is $cart->total_quantity,   21, 'right total quantity count';

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

subtest 'method is_modified' => sub {
    my $cart = _factory_cart;
    is $cart->is_modified, 0, 'right not modified';
    $cart->items->first->is_modified(1);
    is $cart->is_modified, 1, 'right modified';

    $cart = _factory_cart;
    is $cart->is_modified, 0, 'right not modified';
    $cart->shipments->first->is_modified(1);
    is $cart->is_modified, 1, 'right modified';

    # $cart = _factory_cart;
    # $cart->shipments->first->items->first->is_modified(1);
    # is $cart->is_modified, 1, 'right modified';
};

subtest 'method add_item' => sub {
    my $cart = _factory_cart;
    $cart->add_item( Markets::Domain::Entity::Item->new( product_id => 11 ) );
    is_deeply $cart->items->last->to_hash, { product_id => 11 }, 'right item';

    $cart->add_item( Markets::Domain::Entity::Item->new( product_id => 1, quantity => 1 ) );
    is_deeply $cart->items->first->to_hash, { product_id => 1, quantity => 2 }, 'right item';

    is $cart->is_modified, 1, 'right modified';
};

subtest 'method add_shipping_item' => sub {
    my $cart = _factory_cart;
    $cart->add_shipping_item( Markets::Domain::Entity::Item->new( product_id => 11 ) );
    is_deeply $cart->shipments->first->shipping_items->last->to_hash, { product_id => 11 },
      'right shipping_item';

    $cart->add_shipping_item(
        Markets::Domain::Entity::Item->new( product_id => 4, quantity => 4 ) );
    is_deeply $cart->shipments->first->shipping_items->first->to_hash,
      { product_id => 4, quantity => 8 }, 'right sum quantity';

    is $cart->is_modified, 1, 'right modified';
};

subtest 'method clear' => sub {
    my $cart = _factory_cart;
    $cart->clear;
    is_deeply $cart->to_hash, { items => [], shipments => [] };
    is $cart->is_modified,      1, 'right modified';
    is $cart->total_item_count, 0, 'right total item count';
    is $cart->total_quantity,   0, 'right total quantity count';
};

subtest 'method clone' => sub {
    my $cart = _factory_cart;

    $cart->is_modified(1);
    my $clone = $cart->clone;
    is $clone->is_modified, 0, 'right modified';

    is_deeply $cart->to_hash, $clone->to_hash, 'right all data';

    # items
    isnt $cart->items->[0], $clone->items->[0], 'right cart reference';
    is_deeply $cart->items->[0]->to_hash, $clone->items->[0]->to_hash, 'right cart data';

    # shipments
    isnt $cart->shipments->[0], $clone->shipments->[0], 'right shipment reference';
    is_deeply $cart->shipments->[0]->to_hash, $clone->shipments->[0]->to_hash,
      'right shipment data';

    isnt $cart->shipments->[0]->shipping_items->[0], $clone->shipments->[0]->shipping_items->[0],
      'right shipment item reference';
    is_deeply $cart->shipments->[0]->shipping_items->[0]->to_hash,
      $clone->shipments->[0]->shipping_items->[0]->to_hash,
      'right shipment item data';
};

subtest 'method remove_item' => sub {
    my $cart = _factory_cart;
    my $item = Markets::Domain::Entity::Item->new( product_id => 2, quantity => 1 );

    my $id           = $item->id;
    my $removed_item = $cart->remove_item($id);
    is_deeply $cart->to_hash->{items},
      [ { product_id => 1, quantity => 1 }, { product_id => 3, quantity => 3 }, ],
      'right remove item';
    is $removed_item->is_equal($item), 1, 'right return value';
    is $cart->is_modified, 1, 'right modified';

    # Unremove. not found item.
    $cart         = _factory_cart;
    $item         = Markets::Domain::Entity::Item->new( product_id => 123, quantity => 1 );
    $id           = $item->id;
    $removed_item = $cart->remove_item($id);
    is_deeply $cart->to_hash->{items},
      [
        { product_id => 1, quantity => 1 },
        { product_id => 2, quantity => 2 },
        { product_id => 3, quantity => 3 },
      ],
      'right not removed';
    is $removed_item, undef, 'right return value';
    is $cart->is_modified, 0, 'right not modified';
};

subtest 'method merge' => sub {
    my $cart        = _factory_cart;
    my $stored_data = {
        items => [
            { product_id => 4, quantity => 4 },
            { product_id => 1, quantity => 1 },
            { product_id => 5, quantity => 5 },
        ],
        shipments => [],
    };
    my $stored_cart = $app->factory(
        'entity-cart',
        {
            cart_id   => '99999',
            cart_data => $stored_data,
        }
    );

    my $merged_cart = $cart->merge($stored_cart);
    is_deeply $cart->to_hash,        $cart_data,   'right non-destructive';
    is_deeply $stored_cart->to_hash, $stored_data, 'right non-destructive';

    is_deeply $merged_cart->to_hash, {
        items => [
            { product_id => 4, quantity => 4 },
            { product_id => 1, quantity => 2 },
            { product_id => 5, quantity => 5 },
            { product_id => 2, quantity => 2 },
            { product_id => 3, quantity => 3 },
        ],
        shipments => [

            # { address => 'Tokyo', items => [ { product_id => 4, quantity => 4 } ] },
            # { address => 'Osaka', items => [ { product_id => 5, quantity => 5 } ] },
        ],
      },
      'right merge data';
    is $merged_cart->is_modified, 1, 'right modified';
};

done_testing();
