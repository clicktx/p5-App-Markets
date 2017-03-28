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
        { address => 'Tokyo', items => [ { product_id => 4, quantity => 4 } ] },
        { address => 'Osaka', items => [ { product_id => 5, quantity => 5 } ] },
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

subtest 'basic' => sub {
    my $cart = _factory_cart;
    isa_ok $cart, 'Markets::Domain::Entity::Cart';
};

subtest 'attributes' => sub {
    my $cart = _factory_cart;
    is $cart->cart_id,     '12345', 'right cart_id';
    is $cart->is_modified, 0,       'right is_modified';

    isa_ok $cart->items, 'Mojo::Collection', 'right items';
    isa_ok $cart->items->first, 'Markets::Domain::Entity::Item', 'right items';

    isa_ok $cart->shipments, 'Mojo::Collection', 'right shipments';
    isa_ok $cart->shipments->first, 'Markets::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    my $cart = _factory_cart;
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
    my $cart = _factory_cart;
    $cart->add_item( Markets::Domain::Entity::Item->new );
    is_deeply $cart->items->last->to_hash, {}, 'right item';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'method clear' => sub {
    my $cart = _factory_cart;
    $cart->clear;
    is_deeply $cart->to_hash, { items => [], shipments => [] };
    is $cart->is_modified, 1, 'right modified';
};

subtest 'method clone' => sub {
    my $cart  = _factory_cart;
    my $clone = $cart->clone;

    is_deeply $cart->to_hash, $clone->to_hash, 'right all data';

    # items
    isnt $cart->items->[0], $clone->items->[0], 'right cart reference';
    is_deeply $cart->items->[0]->to_hash, $clone->items->[0]->to_hash, 'right cart data';

    # shipments
    isnt $cart->shipments->[0], $clone->shipments->[0], 'right shipment reference';
    is_deeply $cart->shipments->[0]->to_hash, $clone->shipments->[0]->to_hash,
      'right shipment data';

    isnt $cart->shipments->[0]->items->[0], $clone->shipments->[0]->items->[0],
      'right shipment item reference';
    is_deeply $cart->shipments->[0]->items->[0]->to_hash,
      $clone->shipments->[0]->items->[0]->to_hash,
      'right shipment item data';

};
done_testing();
__END__
subtest 'method merge' => sub {
    my $cart        = _factory_cart;
    my $stored_data = {
        items => [
            { product_id => 1, quantity => 1 },
            { product_id => 4, quantity => 4 },
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

    my $merged_cart = $cart->clone->merge($stored_cart);

    is $merged_cart->id, '8cb2237d0679ca88db6464eac60da96345513964', 'right id';

    is_deeply $merged_cart->to_hash, {
        items => [
            { product_id => 1, quantity => 2 },
            { product_id => 4, quantity => 4 },
            { product_id => 5, quantity => 5 },
            { product_id => 2, quantity => 2 },
            { product_id => 3, quantity => 3 },
        ],
        shipments => [
            { address => 'Tokyo', items => [ { product_id => 4, quantity => 4 } ] },
            { address => 'Osaka', items => [ { product_id => 5, quantity => 5 } ] },

        ],
      },
      'right merge data';

    # use DDP;p $merged_cart->to_hash;
    # is_deeply $merged_cart->to_hash,
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
    # say $merged_cart;
    # p $merged_cart->to_hash;
};

done_testing();
