use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;
use Yetie::Factory;

my %example_data = (
    items => [
        {
            product_id    => 1,
            product_title => 'a',
            quantity      => 1,
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule => { round_mode => 'even', tax_rate => 5 },
        },
        {
            product_id    => 2,
            product_title => 'b',
            quantity      => 2,
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule => { round_mode => 'even', tax_rate => 5 },
        },
        {
            product_id    => 3,
            product_title => 'c',
            quantity      => 3,
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule => { round_mode => 'even', tax_rate => 5 },
        },
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
            items => [
                {
                    product_id    => 1,
                    product_title => 'a',
                    quantity      => 1,
                    price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                    tax_rule => { round_mode => 'even', tax_rate => 5 },
                },
            ]
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
                {
                    product_id    => 2,
                    product_title => 'b',
                    quantity      => 2,
                    price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                    tax_rule => { round_mode => 'even', tax_rate => 5 },
                },
                {
                    product_id    => 3,
                    product_title => 'c',
                    quantity      => 3,
                    price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                    tax_rule => { round_mode => 'even', tax_rate => 5 },
                },
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
    my %args = @_;
    %args = %example_data unless @_;

    Yetie::Factory->new('entity-cart')->construct(
        {
            cart_id => '12345',
            %args,
        }
    );
}

use_ok 'Yetie::Domain::Entity::Cart';
use_ok 'Yetie::Domain::Entity::LineItem';

subtest 'basic' => sub {
    my $cart = Yetie::Domain::Entity::Cart->new;
    ok $cart->id;
    isa_ok $cart->items,           'Yetie::Domain::List::LineItems';
    isa_ok $cart->shipments,       'Yetie::Domain::List::Shipments';
    isa_ok $cart->billing_address, 'Yetie::Domain::Entity::Address';
};

subtest 'attributes' => sub {
    my $cart = _create_entity;
    is $cart->cart_id, '12345', 'right cart_id';

    isa_ok $cart->items, 'Yetie::Domain::List::LineItems', 'right items';
    isa_ok $cart->items->first, 'Yetie::Domain::Entity::LineItem', 'right items';

    isa_ok $cart->shipments, 'Yetie::Domain::List::Shipments', 'right shipments';
    isa_ok $cart->shipments->first, 'Yetie::Domain::Entity::Shipment', 'right shipments';
};

subtest 'methods' => sub {
    my $cart      = _create_entity;
    my $cart_data = $cart->to_data;
    my %d         = %example_data;
    my $d         = \%d;
    $d->{billing_address}->{hash}                    = 'f42001ccd9c7f10d05bfd8a9da91674635daba8c';
    $d->{shipments}->[0]->{shipping_address}->{hash} = 'a38d44916394e4d5289b8e5e2cc7b66bcd3f1722';
    $d->{shipments}->[1]->{shipping_address}->{hash} = 'e49e00abbdbcaa37c27e8af5ca11fe33c24703ce';
    cmp_deeply $cart_data, { id => ignore(), cart_id => ignore(), %{$d} }, 'right data structure';
    is $cart->id,                '8cb2237d0679ca88db6464eac60da96345513964', 'right entity id';
    is $cart->count_total_items, 3,                                          'right total total items';
    is $cart->total_quantity,    6,                                          'right total quantity';

    my $cart2 = Yetie::Factory->new('entity-cart')->construct(
        {
            cart_id => '54321',
            %example_data,
        }
    );

    is $cart->equals($cart),  1, 'right equals entity';
    is $cart->equals($cart2), 0, 'right not equals entity';
};

subtest 'add_item' => sub {
    my $cart = _create_entity;
    $cart->add_item( Yetie::Factory->new('entity-line_item')->construct( product_id => 11 ) );
    is $cart->items->last->product_id, '11', 'right last item';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $cart->add_item(
        Yetie::Factory->new('entity-line_item')->construct( product_id => 1, quantity => 1, price => 100 ) );
    is $cart->items->first->quantity, '2', 'right sum quantity';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'add_shipping_item' => sub {
    my $cart = _create_entity;
    $cart->add_shipping_item( 0, Yetie::Factory->new('entity-line_item')->construct( product_id => 11 ) );
    is $cart->shipments->first->items->last->product_id, '11', 'right add shipping_item';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $cart->add_shipping_item( 0,
        Yetie::Factory->new('entity-line_item')->construct( product_id => 4, quantity => 4, price => 100 ) );
    is $cart->shipments->first->items->first->quantity, 1, 'right sum quantity';
    is $cart->is_modified, 1, 'right modified';
};

subtest 'clear_items' => sub {
    my $cart = _create_entity;
    $cart->clear_items;
    is $cart->items->size, 0;
    is $cart->count_total_items, 0;
    is $cart->is_modified, 1, 'right modified';
};

subtest 'clone' => sub {
    my $cart = _create_entity;

    my $clone = $cart->clone;
    is $cart->is_modified,  0, 'right cart not modified';
    is $clone->is_modified, 0, 'right clone not modified';
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

subtest 'has_billing_address' => sub {
    my $cart = Yetie::Factory->new('entity-cart')->construct();
    is $cart->has_billing_address, 0, 'right no address info';

    $cart = _create_entity;
    is $cart->has_billing_address, 1, 'right has address info';
};

subtest 'has_shipping_address' => sub {
    my $cart = Yetie::Factory->new('entity-cart')->construct();
    is $cart->has_shipping_address, 0, 'right has not shipment';

    $cart->shipments->create_shipment;
    is $cart->has_shipping_address, 0, 'right no address info';

    $cart = _create_entity;
    is $cart->has_shipping_address, 1, 'right has address info';
};

subtest 'merge' => sub {
    my $cart        = _create_entity;
    my %stored_data = (
        billing_address => {},
        items           => [
            { product_id => 4, quantity => 4, price => 100 },
            { product_id => 1, quantity => 1, price => 100 },
            { product_id => 5, quantity => 5, price => 100 },
        ],
        shipments => [
            {
                shipping_address => {},
                items            => []
            }
        ],
    );
    my $stored_cart = Yetie::Factory->new('entity-cart')->construct(
        {
            cart_id => '99999',
            %stored_data,
        }
    );

    my %d = %example_data;
    my $d = \%d;
    $d->{cart_id}                                    = '12345';
    $d->{billing_address}->{hash}                    = 'f42001ccd9c7f10d05bfd8a9da91674635daba8c';
    $d->{shipments}->[0]->{shipping_address}->{hash} = 'a38d44916394e4d5289b8e5e2cc7b66bcd3f1722';
    $d->{shipments}->[1]->{shipping_address}->{hash} = 'e49e00abbdbcaa37c27e8af5ca11fe33c24703ce';
    my $cart_data = $cart->to_data;
    cmp_deeply $cart_data, { id => ignore(), %{$d} }, 'right non-destructive';

    %d            = %stored_data;
    $d            = \%d;
    $d->{cart_id} = '99999';
    $d->{billing_address} = { hash => '20f551adf8c892c32845022b874e0763ecf68788', };
    $d->{shipments}->[0]->{shipping_address} = { hash => '20f551adf8c892c32845022b874e0763ecf68788' };
    my $stored_cart_data = $stored_cart->to_data;
    cmp_deeply $stored_cart_data,
      {
        id              => ignore(),
        cart_id         => '99999',
        billing_address => ignore(),
        items           => [
            {
                product_id => 4,
                quantity   => 4,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 1,
                quantity   => 1,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 5,
                quantity   => 5,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
        ],
        shipments => [ { shipping_address => ignore(), items => [] } ],
      },
      'right stored';
    my $merged_cart      = $cart->merge($stored_cart);
    my $merged_cart_data = $merged_cart->to_data;

    cmp_deeply $merged_cart_data,
      {
        id              => ignore(),
        cart_id         => '99999',
        billing_address => ignore(),
        items           => [
            {
                product_id => 4,
                quantity   => 4,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 1,
                quantity   => 2,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id => 5,
                quantity   => 5,
                price      => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule   => ignore(),
            },
            {
                product_id    => 2,
                quantity      => 2,
                product_title => 'b',
                price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule      => ignore(),
            },
            {
                product_id    => 3,
                quantity      => 3,
                product_title => 'c',
                price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                tax_rule      => ignore(),
            },
        ],
        shipments => [ { shipping_address => ignore(), items => [] } ],
      },
      'right merge data';
    is $merged_cart->is_modified, 1, 'right modified';
};

subtest 'remove_item' => sub {
    my $cart = _create_entity;
    dies_ok { $cart->remove_item('foo'); } 'right argument srt';

    $cart->remove_item(2);
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{items},
      [
        {
            product_id    => 1,
            quantity      => 1,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right remove item';

    # Unremove. not found item.
    $cart = _create_entity;
    $cart->remove_item(4);
    is $cart->is_modified, 0, 'right not modified';
    cmp_deeply $cart->to_data->{items},
      [
        {
            product_id    => 1,
            quantity      => 1,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 2,
            quantity      => 2,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right not removed';
};

subtest 'remove_shipping_item' => sub {
    my $cart = _create_entity;
    dies_ok { $cart->remove_shipping_item( 'foo', 2 ) } 'right first argument str';
    dies_ok { $cart->remove_shipping_item( 1,     'foo' ) } 'right second argument str';

    $cart->remove_shipping_item( 1 => 1 );
    is $cart->is_modified, 1, 'right modified';
    cmp_deeply $cart->to_data->{shipments}->[1]->{items},
      [
        {
            product_id    => 3,
            quantity      => 3,
            product_title => 'c',
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right remove shipping item';

    # Unremove. not found item.
    $cart = _create_entity;
    $cart->remove_shipping_item( 1 => 4 );
    is $cart->is_modified, 0, 'right not modified';
    cmp_deeply $cart->to_data->{shipments}->[1]->{items},
      [
        {
            product_id    => 2,
            quantity      => 2,
            product_title => 'b',
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => 'c',
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right not removed';

    $cart->remove_shipping_item( 2 => 1 );
    is $cart->is_modified, 0, 'right not modified';
    cmp_deeply $cart->to_data->{shipments}->[1]->{items},
      [
        {
            product_id    => 2,
            quantity      => 2,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
      ],
      'right not removed';
};

# subtest 'grand_total' => sub {};

subtest 'revert' => sub {
    my $cart = _create_entity;
    ok $cart->revert, 'right cart revert';
    cmp_deeply $cart->items->to_data,
      [
        {
            product_id    => 1,
            quantity      => 1,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 2,
            quantity      => 2,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
        {
            product_id    => 3,
            quantity      => 3,
            product_title => ignore(),
            price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
            tax_rule      => ignore(),
        },
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

    # Without items
    $cart = _create_entity( shipments => [ { items => [] }, { items => [] } ] );
    ok !$cart->revert, 'right without item';
    is $cart->is_modified, 0, 'right not modified';
};

subtest 'set_billing_address' => sub {
    my %address = (
        country_code => 'jp',
        line1        => 'Tokyo',
    );
    my $valid_data = {
        hash          => ignore(),
        country_code  => 'jp',
        city          => q{},
        line1         => 'Tokyo',
        line2         => q{},
        organization  => q{},
        personal_name => q{},
        phone         => q{},
        postal_code   => q{},
        state         => q{},
    };

    my $cart = _create_entity;
    dies_ok { $cart->set_billing_address() } 'right no arguments';

    $cart = _create_entity;
    my $obj = $cart->factory('entity-address')->construct(%address);
    $cart->set_billing_address($obj);
    cmp_deeply $cart->billing_address->to_data, $valid_data, 'right update, data is object';
    is $cart->is_modified, 1, 'right modified';

    # not update
    $cart = _create_entity;
    $obj  = $cart->factory('entity-address')->construct( $example_data{billing_address} );
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
        city          => q{},
        line1         => 'Shimane',
        line2         => q{},
        organization  => q{},
        personal_name => q{},
        phone         => q{},
        postal_code   => q{},
        state         => q{},
    };

    my $cart = _create_entity;
    dies_ok { $cart->set_shipping_address() } 'right not arguments';

    my $obj           = $cart->factory('entity-address')->construct(%address);
    my $shipment_addr = $cart->shipments->get(1)->shipping_address->to_data;

    $cart->set_shipping_address($obj);
    cmp_deeply $cart->shipments->first->shipping_address->to_data, $valid_data, 'right single update';
    cmp_deeply $cart->shipments->get(1)->shipping_address->to_data, $shipment_addr, 'right not update';
    is $cart->is_modified, 1, 'right modified';

    $cart          = _create_entity;
    $shipment_addr = $cart->shipments->get(0)->shipping_address->to_data;
    $cart->set_shipping_address( 1 => $obj );
    cmp_deeply $cart->shipments->get(0)->shipping_address->to_data, $shipment_addr, 'right not update';
    cmp_deeply $cart->shipments->get(1)->shipping_address->to_data, $valid_data,    'right specify update';
    is $cart->is_modified, 1, 'right modified';

    $cart = _create_entity;
    $cart->set_shipping_address( [ $obj, $obj ] );
    cmp_deeply $cart->shipments->get(0)->shipping_address->to_data, $valid_data, 'right multi update';
    cmp_deeply $cart->shipments->get(1)->shipping_address->to_data, $valid_data, 'right multi update';
    is $cart->is_modified, 1, 'right modified';

    # first set(create and set)
    $cart = Yetie::Factory->new('entity-cart')->construct();
    $cart->set_shipping_address($obj);
    cmp_deeply $cart->shipments->get(0)->shipping_address->to_data, $valid_data,
      'right create shipment and set shipping_address';

    # not update
    $cart = _create_entity;
    $obj  = $cart->factory('entity-address')->construct( $example_data{shipments}->[0]->{shipping_address} );
    $cart->set_shipping_address($obj);
    is $cart->is_modified, 0, 'right not modified';
};

subtest 'subtotal' => sub {
    subtest 'excluding tax' => sub {
        my $cart = _create_entity;
        ok $cart->subtotal_excl_tax == 600, 'right subtotal excluding tax';

        # no items
        $cart = Yetie::Factory->new('entity-cart')->construct( cart_id => '12345' );
        ok $cart->subtotal_excl_tax == 0, 'right no items';
    };

    subtest 'including tax' => sub {
        my $cart = _create_entity;
        ok $cart->subtotal_incl_tax == 630, 'right subtotal including tax';

        # no items
        $cart = Yetie::Factory->new('entity-cart')->construct( cart_id => '12345' );
        ok $cart->subtotal_incl_tax == 0, 'right no items';
    };
};

subtest 'to_order_data' => sub {
    my $cart = _create_entity;
    cmp_deeply $cart->to_order_data,
      {
        billing_address => { id => ignore() },
        orders          => [
            {
                items            => ignore(),
                shipping_address => { id => ignore() },
            },
            {
                items            => ignore(),
                shipping_address => { id => ignore() },
            }
        ],
      },
      'right dump order data';
};

done_testing();
