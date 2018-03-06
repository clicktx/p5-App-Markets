use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Domain::Factory;

my $test_data = {
    items => [
        { product_id => 1, quantity => 1, price => 100 },
        { product_id => 2, quantity => 2, price => 100 },
        { product_id => 3, quantity => 3, price => 100 },
    ],
    shipments => [
        {
            shipping_address => { line1 => 'Tokyo' },
            items => [ { product_id => 4, quantity => 4, price => 100 } ]
        },
        {
            shipping_address => { line1 => 'Osaka' },
            items            => [
                { product_id => 4, quantity => 4, price => 100 },
                { product_id => 5, quantity => 5, price => 100 },
                { product_id => 6, quantity => 6, price => 100 },
            ]
        },
    ],
    billing_address => { line1 => 'Gunma' },
};

sub _create_entity {
    Yetie::Domain::Factory->new('entity-cart')->create(
        {
            cart_id => '12345',
            %{$test_data},
        }
    );
}

use_ok 'Yetie::Domain::Entity::Cart::Item';

subtest 'basic' => sub {
    my $cart = Yetie::Domain::Factory->new('entity-cart')->create();
    isa_ok $cart, 'Yetie::Domain::Entity';

    ok $cart->id;
    isa_ok $cart->items,     'Yetie::Domain::Collection';
    isa_ok $cart->shipments, 'Yetie::Domain::Collection';
};

subtest 'attributes' => sub {
    my $cart = _create_entity;
    is $cart->cart_id, '12345', 'right cart_id';

    isa_ok $cart->items, 'Yetie::Domain::Collection', 'right items';
    isa_ok $cart->items->first, 'Yetie::Domain::Entity::Cart::Item', 'right items';

    isa_ok $cart->shipments, 'Yetie::Domain::Collection', 'right shipments';
    isa_ok $cart->shipments->first, 'Yetie::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    my $cart = _create_entity;
    cmp_deeply $cart->to_data, { cart_id => ignore(), %{$test_data} }, 'right data structure';
    is $cart->id,               '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->total_item_count, 7,                                          'right total item count';
    is $cart->total_quantity,   25,                                         'right total quantity count';

    my $cart2 = Yetie::Domain::Factory->new('entity-cart')->create(
        {
            cart_id => '54321',
            %{$test_data},
        }
    );

    is $cart->equal($cart),  1, 'right equal entity';
    is $cart->equal($cart2), 0, 'right not equal entity';
};

subtest 'add_item' => sub {
    my $cart = _create_entity;
    $cart->add_item( Yetie::Domain::Entity::Cart::Item->new( product_id => 11 ) );
    cmp_deeply $cart->items->last->to_data, { product_id => 11 }, 'right item';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $cart->add_item( Yetie::Domain::Entity::Cart::Item->new( product_id => 1, quantity => 1 ) );
    cmp_deeply $cart->items->first->to_data, { product_id => 1, quantity => 2, price => 100 }, 'right item';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'add_shipping_item' => sub {
    my $cart = _create_entity;
    $cart->add_shipping_item( 0, Yetie::Domain::Entity::Cart::Item->new( product_id => 11 ) );
    cmp_deeply $cart->shipments->first->items->last->to_data, { product_id => 11 }, 'right shipping_item';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $cart->add_shipping_item( 0,
        Yetie::Domain::Entity::Cart::Item->new( product_id => 4, quantity => 4, price => 100 ) );
    cmp_deeply $cart->shipments->first->items->first->to_data,
      { product_id => 4, quantity => 8, price => 100 }, 'right sum quantity';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'clear' => sub {
    my $cart = _create_entity;
    $cart->clear;
    is $cart->items->size, 0;

    # NOTE: itemsは削除するべきか？
    # is $cart->total_item_count, 0;
};

subtest 'clone' => sub {
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

    isnt $cart->shipments->[0]->items->[0], $clone->shipments->[0]->items->[0], 'right shipment item reference';
    cmp_deeply $cart->shipments->[0]->items->[0]->to_data,
      $clone->shipments->[0]->items->[0]->to_data,
      'right shipment item data';
};

subtest 'remove_item' => sub {
    my $cart = _create_entity;
    my $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 2, quantity => 1 );
    my $id   = $item->id;

    my $removed_item = $cart->remove_item($id);
    is $removed_item->equal($item), 1, 'right return value';
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{items},
      [ { product_id => 1, quantity => 1, price => 100 }, { product_id => 3, quantity => 3, price => 100 }, ],
      'right remove item';

    # Unremove. not found item.
    $cart = _create_entity;
    $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 123, quantity => 1 );
    $id   = $item->id;

    $removed_item = $cart->remove_item($id);
    is $removed_item, undef, 'right return value';
    is $cart->is_modified, 0, 'right not modified';
    cmp_deeply $cart->to_data->{items},
      [
        { product_id => 1, quantity => 1, price => 100 },
        { product_id => 2, quantity => 2, price => 100 },
        { product_id => 3, quantity => 3, price => 100 },
      ],
      'right not removed';
};

subtest 'remove_shipping_item' => sub {
    my $cart = _create_entity;
    my $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 4 );
    my $id   = $item->id;

    my $removed_item = $cart->remove_shipping_item( 1, $id );
    is $removed_item->equal($item), 1, 'right return value';
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{shipments}->[1]->{items},
      [ { product_id => 5, quantity => 5, price => 100 }, { product_id => 6, quantity => 6, price => 100 }, ],
      'right remove shipping item';

    # Unremove. not found item.
    $cart = _create_entity;
    $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 123 );
    $id   = $item->id;

    $removed_item = $cart->remove_shipping_item( 1, $id );
    is $removed_item, undef, 'right return value';
    is $cart->is_modified, 0, 'right not modified';
    cmp_deeply $cart->to_data->{shipments}->[1]->{items},
      [
        { product_id => 4, quantity => 4, price => 100 },
        { product_id => 5, quantity => 5, price => 100 },
        { product_id => 6, quantity => 6, price => 100 },
      ],
      'right not removed';
};

# subtest 'grand_total' => sub {};

subtest 'subtotal' => sub {
    my $cart = _create_entity;
    is $cart->subtotal, 2500, 'right grand total';
};

subtest 'merge' => sub {
    my $cart        = _create_entity;
    my $stored_data = {
        items => [
            { product_id => 4, quantity => 4, price => 100 },
            { product_id => 1, quantity => 1, price => 100 },
            { product_id => 5, quantity => 5, price => 100 },
        ],
        shipments => [ { shipping_address => {}, items => [] } ],
    };
    my $stored_cart = Yetie::Domain::Factory->new('entity-cart')->create(
        {
            cart_id => '99999',
            %{$stored_data},
        }
    );
    my $merged_cart = $cart->merge($stored_cart);
    cmp_deeply $cart->to_data,
      {
        cart_id         => '12345',
        billing_address => ignore(),
        %{$test_data}
      },
      'right non-destructive';
    cmp_deeply $stored_cart->to_data,
      {
        cart_id         => '99999',
        billing_address => ignore(),
        %{$stored_data}
      },
      'right non-destructive';
    cmp_deeply $merged_cart->to_data,
      {
        cart_id         => '99999',
        billing_address => ignore(),
        items           => [
            { product_id => 4, quantity => 4, price => 100 },
            { product_id => 1, quantity => 2, price => 100 },
            { product_id => 5, quantity => 5, price => 100 },
            { product_id => 2, quantity => 2, price => 100 },
            { product_id => 3, quantity => 3, price => 100 },
        ],
        shipments => [ { shipping_address => {}, items => [] } ],
      },
      'right merge data';
    is $merged_cart->_is_modified, 1, 'right modified';
};

subtest 'order data' => sub {
    my $cart       = _create_entity;
    my $order_data = { %{ $cart->to_data } };
    delete $order_data->{cart_id};
    delete $order_data->{items};

    cmp_deeply $cart->to_order_data, $order_data, 'right order data';
};

done_testing();
