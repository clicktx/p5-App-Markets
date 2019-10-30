use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::Checkout';

my %example_data = (
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
                    tax_rule => { tax_rate => 5 },
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
                    tax_rule => { tax_rate => 5 },
                },
                {
                    product_id    => 3,
                    product_title => 'c',
                    quantity      => 3,
                    price         => { value => 100, currency_code => 'USD', is_tax_included => 0 },
                    tax_rule => { tax_rate => 5 },
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
    Yetie::Factory->new('entity-checkout')->construct(%args);
}

subtest 'add_shipment_item' => sub {
    my $checkout = _create_entity;
    my $res =
      $checkout->add_shipment_item( 0 => Yetie::Factory->new('entity-line_item')->construct( product_id => 11 ) );
    is $checkout->shipments->first->items->last->product_id, 11, 'right add shipping_item';
    is $checkout->is_modified, 1, 'right modified';
    isa_ok $res, 'Yetie::Domain::Entity::Checkout';

    $checkout = _create_entity;
    $checkout->add_shipment_item( Yetie::Factory->new('entity-line_item')->construct( product_id => 99 ) );
    is $checkout->shipments->first->items->last->product_id, 99, 'right add shipping_item';
    is $checkout->is_modified, 1, 'right modified';
};

subtest 'get_order_data' => sub {
    my $checkout = _create_entity;
    cmp_deeply $checkout->get_order_data,
      {
        billing_address => { id => ignore() },
        orders          => [
            {
                items            => ignore(),
                shipping_address => { id => ignore() },
                shipping_fee     => ignore(),
                tax_rule         => ignore(),
            },
            {
                items            => ignore(),
                shipping_address => { id => ignore() },
                shipping_fee     => ignore(),
                tax_rule         => ignore(),
            }
        ],
      },
      'right dump order data';
};

subtest 'has_billing_address' => sub {
    my $checkout = Yetie::Factory->new('entity-checkout')->construct();
    is $checkout->has_billing_address, 0, 'right no address info';

    $checkout = _create_entity;
    is $checkout->has_billing_address, 1, 'right has address info';
};

subtest 'has_shipping_address' => sub {
    my $checkout = Yetie::Factory->new('entity-checkout')->construct();
    is $checkout->has_shipping_address, 0, 'right has not shipment';

    $checkout->shipments->create_shipment;
    is $checkout->has_shipping_address, 0, 'right no address info';

    $checkout = _create_entity;
    is $checkout->has_shipping_address, 1, 'right has address info';
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

    my $checkout = _create_entity;
    dies_ok { $checkout->set_billing_address() } 'right no arguments';

    $checkout = _create_entity;
    my $obj = $checkout->factory('entity-address')->construct(%address);
    $checkout->set_billing_address($obj);
    cmp_deeply $checkout->billing_address->to_data, $valid_data, 'right update, data is object';
    is $checkout->is_modified, 1, 'right modified';

    # not update
    # $checkout = _create_entity;
    # $obj      = $checkout->factory('entity-address')->construct( $example_data{billing_address} );
    # $checkout->set_billing_address($obj);
    # is $checkout->is_modified, 0, 'right not modified';
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

    my $checkout = _create_entity;
    dies_ok { $checkout->set_shipping_address() } 'right not arguments';

    $checkout->shipments->create_shipment;
    my $obj           = $checkout->factory('entity-address')->construct(%address);
    my $shipment_addr = $checkout->shipments->get(1)->shipping_address->to_data;

    $checkout->set_shipping_address($obj);
    cmp_deeply $checkout->shipments->first->shipping_address->to_data, $valid_data, 'right single update';
    cmp_deeply $checkout->shipments->get(1)->shipping_address->to_data, $shipment_addr, 'right not update';
    is $checkout->is_modified, 1, 'right modified';

    $checkout      = _create_entity;
    $shipment_addr = $checkout->shipments->get(0)->shipping_address->to_data;
    $checkout->set_shipping_address( 1 => $obj );
    cmp_deeply $checkout->shipments->get(0)->shipping_address->to_data, $shipment_addr, 'right not update';
    cmp_deeply $checkout->shipments->get(1)->shipping_address->to_data, $valid_data,    'right specify update';
    is $checkout->is_modified, 1, 'right modified';

    $checkout = _create_entity;
    $checkout->set_shipping_address( [ $obj, $obj ] );
    cmp_deeply $checkout->shipments->get(0)->shipping_address->to_data, $valid_data, 'right multi update';
    cmp_deeply $checkout->shipments->get(1)->shipping_address->to_data, $valid_data, 'right multi update';
    is $checkout->is_modified, 1, 'right modified';

    # first set(create and set)
    $checkout = Yetie::Factory->new('entity-checkout')->construct();
    $checkout->shipments->create_shipment;
    $checkout->set_shipping_address($obj);
    cmp_deeply $checkout->shipments->get(0)->shipping_address->to_data, $valid_data,
      'right create shipment and set shipping_address';

    # not update
    $checkout = _create_entity;
    $obj      = $checkout->factory('entity-address')->construct( $example_data{shipments}->[0]->{shipping_address} );
    $checkout->set_shipping_address($obj);
    is $checkout->is_modified, 0, 'right not modified';
};

done_testing();
