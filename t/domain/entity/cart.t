use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Domain::Factory;

my %test_data = (
    email => 'a@example.org',
    items => [
        { product_id => 1, quantity => 1, price => 100 },
        { product_id => 2, quantity => 2, price => 100 },
        { product_id => 3, quantity => 3, price => 100 },
    ],
    shipments => [
        {
            shipping_address => {
                country_code  => 'jp',
                city          => '',
                state         => '',
                line1         => 'Tokyo',
                line2         => '',
                postal_code   => '',
                personal_name => '',
                organization  => '',
                phone         => '',
            },
            items => [ { product_id => 4, quantity => 4, price => 100 } ]
        },
        {
            shipping_address => {
                country_code  => 'jp',
                city          => '',
                state         => '',
                line1         => 'Osaka',
                line2         => '',
                postal_code   => '',
                personal_name => '',
                organization  => '',
                phone         => '',
            },
            items => [
                { product_id => 4, quantity => 4, price => 100 },
                { product_id => 5, quantity => 5, price => 100 },
                { product_id => 6, quantity => 6, price => 100 },
            ]
        },
    ],
    billing_address => {
        country_code  => 'jp',
        city          => '',
        state         => '',
        line1         => 'Gunma',
        line2         => '',
        postal_code   => '',
        personal_name => '',
        organization  => '',
        phone         => '',
    },
);

sub _create_entity {
    Yetie::Domain::Factory->new('entity-cart')->construct(
        {
            cart_id => '12345',
            %test_data,
        }
    );
}

use_ok 'Yetie::Domain::Entity::Cart';
use_ok 'Yetie::Domain::Entity::Cart::Item';

subtest 'basic' => sub {
    my $cart = Yetie::Domain::Entity::Cart->new;
    ok $cart->id;
    isa_ok $cart->items,           'Yetie::Domain::List::CartItems';
    isa_ok $cart->shipments,       'Yetie::Domain::List::Shipments';
    isa_ok $cart->billing_address, 'Yetie::Domain::Entity::Address';
    isa_ok $cart->email,           'Yetie::Domain::Value::Email';
};

subtest 'attributes' => sub {
    my $cart = _create_entity;
    is $cart->cart_id, '12345', 'right cart_id';

    isa_ok $cart->items, 'Yetie::Domain::List::CartItems', 'right items';
    isa_ok $cart->items->first, 'Yetie::Domain::Entity::Cart::Item', 'right items';

    isa_ok $cart->shipments, 'Yetie::Domain::List::Shipments', 'right shipments';
    isa_ok $cart->shipments->first, 'Yetie::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    my $cart      = _create_entity;
    my $cart_data = $cart->to_data;
    my %d         = %test_data;
    my $d         = \%d;
    $d->{billing_address}->{hash}                    = 'f42001ccd9c7f10d05bfd8a9da91674635daba8c';
    $d->{shipments}->[0]->{shipping_address}->{hash} = 'a38d44916394e4d5289b8e5e2cc7b66bcd3f1722';
    $d->{shipments}->[1]->{shipping_address}->{hash} = 'e49e00abbdbcaa37c27e8af5ca11fe33c24703ce';
    cmp_deeply $cart_data, { cart_id => ignore(), %{$d} }, 'right data structure';
    is $cart->id,              '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->total_item_size, 7,                                          'right total item count';
    is $cart->total_quantity,  25,                                         'right total quantity count';

    my $cart2 = Yetie::Domain::Factory->new('entity-cart')->construct(
        {
            cart_id => '54321',
            %test_data,
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
    $cart->add_item( Yetie::Domain::Entity::Cart::Item->new( product_id => 1, quantity => 1, price => 100 ) );
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

subtest 'clear_items' => sub {
    my $cart = _create_entity;
    $cart->clear_items;
    is $cart->items->size, 0;
    is $cart->total_item_size, 0;
    is $cart->is_modified, 1, 'right modified';
};

subtest 'clone' => sub {
    my $cart = _create_entity;

    $cart->is_modified(1);
    my $clone = $cart->clone;
    is $clone->is_modified, 0, 'right modified';
    cmp_deeply $cart->to_data, $clone->to_data, 'right all data';

    # items
    isnt $cart->items->list->[0], $clone->items->list->[0], 'right cart reference';
    cmp_deeply $cart->items->list->[0]->to_data, $clone->items->list->[0]->to_data, 'right cart data';

    # shipments
    isnt $cart->shipments->get(0), $clone->shipments->get(0), 'right shipment reference';
    cmp_deeply $cart->shipments->get(0)->to_data, $clone->shipments->get(0)->to_data, 'right shipment data';

    isnt $cart->shipments->get(0)->items->get(0), $clone->shipments->get(0)->items->get(0),
      'right shipment item reference';
    cmp_deeply $cart->shipments->get(0)->items->get(0)->to_data,
      $clone->shipments->get(0)->items->get(0)->to_data,
      'right shipment item data';
};

subtest 'merge' => sub {
    my $cart        = _create_entity;
    my %stored_data = (
        email => '',
        items => [
            { product_id => 4, quantity => 4, price => 100 },
            { product_id => 1, quantity => 1, price => 100 },
            { product_id => 5, quantity => 5, price => 100 },
        ],
        shipments => [
            {
                shipping_address => {
                    country_code => '',
                    line1        => '',
                    line2        => '',
                    city         => '',
                    state        => '',
                    postal_code  => '',
                    phone        => '',
                },
                items => []
            }
        ],
    );
    my $stored_cart = Yetie::Domain::Factory->new('entity-cart')->construct(
        {
            cart_id => '99999',
            %stored_data,
        }
    );

    my %d = %test_data;
    my $d = \%d;
    $d->{cart_id}                                    = '12345';
    $d->{billing_address}->{hash}                    = 'f42001ccd9c7f10d05bfd8a9da91674635daba8c';
    $d->{shipments}->[0]->{shipping_address}->{hash} = 'a38d44916394e4d5289b8e5e2cc7b66bcd3f1722';
    $d->{shipments}->[1]->{shipping_address}->{hash} = 'e49e00abbdbcaa37c27e8af5ca11fe33c24703ce';
    my $cart_data = $cart->to_data;
    cmp_deeply $cart_data, $d, 'right non-destructive';

    %d                    = %stored_data;
    $d                    = \%d;
    $d->{cart_id}         = '99999';
    $d->{billing_address} = {
        hash          => '20f551adf8c892c32845022b874e0763ecf68788',
        country_code  => '',
        line1         => '',
        line2         => '',
        city          => '',
        state         => '',
        postal_code   => '',
        personal_name => '',
        organization  => '',
        phone         => '',
    };
    $d->{shipments}->[0]->{shipping_address} = {
        hash          => '20f551adf8c892c32845022b874e0763ecf68788',
        country_code  => '',
        line1         => '',
        line2         => '',
        city          => '',
        state         => '',
        postal_code   => '',
        personal_name => '',
        organization  => '',
        phone         => '',
    };
    my $stored_cart_data = $stored_cart->to_data;
    cmp_deeply $stored_cart_data, $d, 'right stored';
    my $merged_cart      = $cart->merge($stored_cart);
    my $merged_cart_data = $merged_cart->to_data;

    cmp_deeply $merged_cart_data,
      {
        cart_id         => '99999',
        email           => '',
        billing_address => ignore(),
        items           => [
            { product_id => 4, quantity => 4, price => 100 },
            { product_id => 1, quantity => 2, price => 100 },
            { product_id => 5, quantity => 5, price => 100 },
            { product_id => 2, quantity => 2, price => 100 },
            { product_id => 3, quantity => 3, price => 100 },
        ],
        shipments => [ { shipping_address => ignore(), items => [] } ],
      },
      'right merge data';
    is $merged_cart->is_modified, 1, 'right modified';
};

subtest 'remove_item' => sub {
    my $cart = _create_entity;
    my $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 2, quantity => 1 );
    my $id   = $item->id;

    $cart->remove_item($id);
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{items},
      [ { product_id => 1, quantity => 1, price => 100 }, { product_id => 3, quantity => 3, price => 100 }, ],
      'right remove item';

    # Unremove. not found item.
    $cart = _create_entity;
    $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 123, quantity => 1 );
    $id   = $item->id;

    $cart->remove_item($id);
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

    $cart->remove_shipping_item( 1, $id );
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{shipments}->[1]->{items},
      [ { product_id => 5, quantity => 5, price => 100 }, { product_id => 6, quantity => 6, price => 100 }, ],
      'right remove shipping item';

    # Unremove. not found item.
    $cart = _create_entity;
    $item = Yetie::Domain::Entity::Cart::Item->new( product_id => 123 );
    $id   = $item->id;

    $cart->remove_shipping_item( 1, $id );
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

subtest 'revert' => sub {
    my $cart = _create_entity;
    $cart->revert;
    is_deeply $cart->items->to_data,
      [
        { product_id => 1, quantity => 1, price => 100 },
        { product_id => 2, quantity => 2, price => 100 },
        { product_id => 3, quantity => 3, price => 100 },
      ],
      'right items';

    is $cart->shipments->size, 1, 'right shipments';
    cmp_deeply $cart->shipments->first->to_data,
      {
        items            => [],
        shipping_address => {
            hash          => ignore(),
            country_code  => 'jp',
            city          => '',
            state         => '',
            line1         => 'Tokyo',
            line2         => '',
            postal_code   => '',
            personal_name => '',
            organization  => '',
            phone         => '',
        },
      },
      'right shipment';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'subtotal' => sub {
    my $cart = _create_entity;
    is $cart->subtotal, 2500, 'right subtotal';

    # no items
    $cart = Yetie::Domain::Factory->new('entity-cart')->construct( cart_id => '12345' );
    $cart->subtotal, 0, 'right no items';
};

subtest 'to_order_data' => sub {
    my $cart       = _create_entity;
    my $order_data = { %{ $cart->to_data } };
    delete $order_data->{cart_id};
    delete $order_data->{items};
    cmp_deeply $cart->to_order_data, $order_data, 'right order data';
};

subtest 'set_billing_address' => sub {
    my %address = (
        country_code => 'jp',
        line1        => 'Tokyo',
    );
    my $valid_data = {
        hash          => ignore(),
        country_code  => 'jp',
        city          => '',
        state         => '',
        line1         => 'Tokyo',
        line2         => '',
        postal_code   => '',
        personal_name => '',
        organization  => '',
        phone         => '',
    };

    my $cart = _create_entity;
    eval { $cart->set_billing_address() };
    ok $@, 'right no arguments';

    $cart = _create_entity;
    my $obj = $cart->factory('entity-address')->construct(%address);
    $cart->set_billing_address($obj);
    cmp_deeply $cart->billing_address->to_data, $valid_data, 'right update, data is object';
    is $cart->is_modified, 1, 'right modified';

    # not update
    $cart = _create_entity;
    $obj  = $cart->factory('entity-address')->construct( $test_data{billing_address} );
    $cart->set_billing_address($obj);
    is $cart->is_modified, 0, 'right not modified';
};

subtest 'set_shipping_address' => sub {
    my %address = (
        country_code => 'jp',
        line1        => 'Shimane',
    );
    my $valid_data = {
        hash          => ignore(),
        country_code  => 'jp',
        city          => '',
        state         => '',
        line1         => 'Shimane',
        line2         => '',
        postal_code   => '',
        personal_name => '',
        organization  => '',
        phone         => '',
    };

    my $cart = _create_entity;
    eval { $cart->set_shipping_address() };
    ok $@, 'right not arguments';

    my $obj = $cart->factory('entity-address')->construct(%address);
    my $i   = $cart->set_shipping_address($obj);
    cmp_deeply $cart->shipments->first->shipping_address->to_data, $valid_data, 'right single update';
    is $i, 1, 'right update quantity';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    my $shipment_addr = $cart->shipments->get(0)->shipping_address->to_data;
    $i = $cart->set_shipping_address( 1 => $obj );
    cmp_deeply $cart->shipments->get(0)->shipping_address->to_data, $shipment_addr, 'right not update';
    cmp_deeply $cart->shipments->get(1)->shipping_address->to_data, $valid_data,    'right specify update';
    is $i, 1, 'right update quantity';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $i = $cart->set_shipping_address( [ $obj, $obj ] );
    cmp_deeply $cart->shipments->get(0)->shipping_address->to_data, $valid_data, 'right multi update';
    cmp_deeply $cart->shipments->get(1)->shipping_address->to_data, $valid_data, 'right multi update';
    is $i, 2, 'right update quantity';
    is $cart->is_modified, 1, 'right modified';

    # not update
    $cart = _create_entity;
    $obj  = $cart->factory('entity-address')->construct( $test_data{shipments}->[0]->{shipping_address} );
    $cart->set_shipping_address($obj);
    is $cart->is_modified, 0, 'right not modified';
};

done_testing();
