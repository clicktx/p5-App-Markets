use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Yetie::Domain::Factory';
use_ok 'Yetie::Domain::Factory::Cart';

my $shipments = bless [
    bless {
        shipping_address => ( bless {}, 'Yetie::Domain::Entity::Address' ),
        items => ( bless [], 'Yetie::Domain::Collection' ),
    },
    'Yetie::Domain::Entity::Shipment'
  ],
  'Yetie::Domain::Collection';

subtest 'argument empty' => sub {
    my $e = $pkg->new('entity-cart')->create_entity;
    cmp_deeply $e,
      bless {
        items => ( bless [], 'Yetie::Domain::Collection' ),
        shipments       => $shipments,
        billing_address => ( bless {}, 'Yetie::Domain::Entity::Address' ),
      },
      'Yetie::Domain::Entity::Cart';
};

subtest 'shipments empty hash ref' => sub {
    my $e = $pkg->new( 'entity-cart', { shipments => [] } )->create_entity;
    cmp_deeply $e,
      bless {
        items           => ignore(),
        shipments       => $shipments,
        billing_address => ignore(),
      },
      'Yetie::Domain::Entity::Cart';
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new('entity-cart')->create_entity;
    cmp_deeply $e,
      bless {
        items => ( bless [], 'Yetie::Domain::Collection' ),
        shipments       => ignore(),
        billing_address => ignore(),
      },
      'Yetie::Domain::Entity::Cart';
};

subtest 'argument items data only' => sub {
    my $e = $pkg->new(
        'entity-cart',
        {
            items => [ {} ],
        }
    )->create_entity;
    cmp_deeply $e,
      bless {
        items => ( bless [ ( bless {}, 'Yetie::Domain::Entity::SellingItem' ) ], 'Yetie::Domain::Collection' ),
        shipments       => ignore(),
        billing_address => ignore(),
      },
      'Yetie::Domain::Entity::Cart';
};

subtest 'argument shipments data only' => sub {
    my $e = $pkg->new( 'entity-cart', { shipments => [ { items => [ {}, {} ] } ] }, )->create_entity;
    $shipments->[0]->{items} =
      bless [ ( bless {}, 'Yetie::Domain::Entity::SellingItem' ), ( bless {}, 'Yetie::Domain::Entity::SellingItem' ) ],
      'Yetie::Domain::Collection';
    cmp_deeply $e,
      bless {
        items           => ignore(),
        shipments       => $shipments,
        billing_address => ignore(),
      },
      'Yetie::Domain::Entity::Cart';
};

done_testing;
