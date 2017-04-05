use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;
use t::Util;

my $t         = Test::Mojo->new('App');
my $app       = $t->app;
my $test_data = {
    items =>
      [ { product_id => 1, quantity => 1 }, { product_id => 2, quantity => 2 }, { product_id => 3, quantity => 3 }, ],
    shipments => [
        { shipping_address => 'Tokyo', shipping_items => [ { product_id => 4, quantity => 4 } ] },
        {
            shipping_address => 'Osaka',
            shipping_items   => [ { product_id => 5, quantity => 5 }, { product_id => 6, quantity => 6 } ]
        },
    ],
};

sub _create_entity {
    $app->factory(
        'entity-cart',
        {
            cart_id   => '12345',
            cart_data => { %{$test_data} },
        }
    )->create;
}

use_ok 'Markets::Domain::Entity::Item';

subtest 'basic' => sub {
    my $cart = $app->factory('entity-cart')->create;
    isa_ok $cart, 'Markets::Domain::Entity';

    ok $cart->id;
    isa_ok $cart->items,     'Markets::Domain::Collection';
    isa_ok $cart->shipments, 'Markets::Domain::Collection';
};

subtest 'attributes' => sub {
    my $cart = _create_entity;
    is $cart->cart_id, '12345', 'right cart_id';

    isa_ok $cart->items, 'Mojo::Collection', 'right items';
    isa_ok $cart->items->first, 'Markets::Domain::Entity::Item', 'right items';

    isa_ok $cart->shipments, 'Mojo::Collection', 'right shipments';
    isa_ok $cart->shipments->first, 'Markets::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    my $cart = _create_entity;
    cmp_deeply $cart->to_data, $test_data, 'right data structure';
    is $cart->id,               '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->total_item_count, 6,                                          'right total item count';
    is $cart->total_quantity,   21,                                         'right total quantity count';

    my $cart2 = $app->factory(
        'entity-cart',
        {
            cart_id   => '54321',
            cart_data => { %{$test_data} },
        }
    )->create;
    is $cart->is_equal($cart),  1, 'right equal entity';
    is $cart->is_equal($cart2), 0, 'right not equal entity';
};

subtest 'method is_modified' => sub {
    my $cart = _create_entity;
    is $cart->is_modified, 0, 'right not modified';
    $cart->items->first->is_modified(1);
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    is $cart->is_modified, 0, 'right not modified';
    $cart->shipments->first->is_modified(1);
    is $cart->is_modified, 1, 'right modified';

    # $cart = _create_entity;
    # $cart->shipments->first->items->first->is_modified(1);
    # is $cart->is_modified, 1, 'right modified';
};

subtest 'method add_item' => sub {
    my $cart = _create_entity;
    $cart->add_item( Markets::Domain::Entity::Item->new( product_id => 11 ) );
    cmp_deeply $cart->items->last->to_data, { product_id => 11 }, 'right item';

    $cart->add_item( Markets::Domain::Entity::Item->new( product_id => 1, quantity => 1 ) );
    cmp_deeply $cart->items->first->to_data, { product_id => 1, quantity => 2 }, 'right item';

    is $cart->is_modified, 1, 'right modified';
};

subtest 'method add_shipping_item' => sub {
    my $cart = _create_entity;
    $cart->add_shipping_item( Markets::Domain::Entity::Item->new( product_id => 11 ) );
    cmp_deeply $cart->shipments->first->shipping_items->last->to_data, { product_id => 11 }, 'right shipping_item';

    $cart->add_shipping_item( Markets::Domain::Entity::Item->new( product_id => 4, quantity => 4 ) );
    cmp_deeply $cart->shipments->first->shipping_items->first->to_data,
      { product_id => 4, quantity => 8 }, 'right sum quantity';

    is $cart->is_modified, 1, 'right modified';
};

subtest 'method clear' => sub {
    my $cart = _create_entity;
    $cart->clear;
    cmp_deeply $cart->to_data, { items => [], shipments => [] };
    is $cart->is_modified,      1, 'right modified';
    is $cart->total_item_count, 0, 'right total item count';
    is $cart->total_quantity,   0, 'right total quantity count';
};

subtest 'method clone' => sub {
    my $cart = _create_entity;

    $cart->is_modified(1);
    my $clone = $cart->clone;
    is $clone->is_modified, 0, 'right modified';
    cmp_deeply $cart->to_data, $clone->to_data, 'right all data';

    # items
    isnt $cart->items->[0], $clone->items->[0], 'right cart reference';
    cmp_deeply $cart->items->[0]->to_data, $clone->items->[0]->to_data, 'right cart data';

    # shipments
    isnt $cart->shipments->[0], $clone->shipments->[0], 'right shipment reference';
    cmp_deeply $cart->shipments->[0]->to_data, $clone->shipments->[0]->to_data, 'right shipment data';

    isnt $cart->shipments->[0]->shipping_items->[0], $clone->shipments->[0]->shipping_items->[0],
      'right shipment item reference';
    cmp_deeply $cart->shipments->[0]->shipping_items->[0]->to_data,
      $clone->shipments->[0]->shipping_items->[0]->to_data,
      'right shipment item data';
};

subtest 'method remove_item' => sub {
    my $cart = _create_entity;
    my $item = Markets::Domain::Entity::Item->new( product_id => 2, quantity => 1 );

    my $id           = $item->id;
    my $removed_item = $cart->remove_item($id);
    cmp_deeply $cart->to_data->{items},
      [ { product_id => 1, quantity => 1 }, { product_id => 3, quantity => 3 }, ],
      'right remove item';
    is $removed_item->is_equal($item), 1, 'right return value';
    is $cart->is_modified, 1, 'right modified';

    # Unremove. not found item.
    $cart         = _create_entity;
    $item         = Markets::Domain::Entity::Item->new( product_id => 123, quantity => 1 );
    $id           = $item->id;
    $removed_item = $cart->remove_item($id);
    cmp_deeply $cart->to_data->{items},
      [ { product_id => 1, quantity => 1 }, { product_id => 2, quantity => 2 }, { product_id => 3, quantity => 3 }, ],
      'right not removed';
    is $removed_item, undef, 'right return value';
    is $cart->is_modified, 0, 'right not modified';
};

subtest 'method merge' => sub {
    my $cart        = _create_entity;
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
            cart_data => { %{$stored_data} },
        }
    )->create;

    my $merged_cart = $cart->merge($stored_cart);
    cmp_deeply $cart->to_data,        $test_data,   'right non-destructive';
    cmp_deeply $stored_cart->to_data, $stored_data, 'right non-destructive';
    cmp_deeply $merged_cart->to_data, {
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
