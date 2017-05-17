use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Markets::Domain::Factory::Entity::Cart';
use_ok 'Markets::Domain::Factory::Entity::Cart';

my $shipments = bless [
    bless {
        shipping_address => ( bless {}, 'Markets::Domain::Entity::Address' ),
        shipping_items => ( bless [], 'Markets::Domain::Collection' ),
    },
    'Markets::Domain::Entity::Shipment'
  ],
  'Markets::Domain::Collection';

subtest 'argument empty' => sub {
    my $e = $pkg->new->create_entity;
    cmp_deeply $e,
      bless {
        items => ( bless [], 'Markets::Domain::Collection' ),
        shipments => $shipments,
        billing_address => ( bless {}, 'Markets::Domain::Entity::Address' ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'shipments empty hash ref' => sub {
    my $e = $pkg->new( { shipments => [] } )->create_entity;
    cmp_deeply $e,
      bless {
        items     => ignore(),
        shipments => $shipments,
        billing_address => ignore(),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new()->create_entity;
    cmp_deeply $e,
      bless {
        items => ( bless [], 'Markets::Domain::Collection' ),
        shipments => ignore(),
        billing_address => ignore(),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'argument items data only' => sub {
    my $e = $pkg->new(
        {
            foo   => 'bar',
            fizz  => 'buzz',
            items => [ {} ],
        }
    )->create_entity;
    cmp_deeply $e,
      bless {
        foo       => 'bar',
        fizz      => 'buzz',
        items     => ( bless [ ( bless {}, 'Markets::Domain::Entity::Item' ) ], 'Markets::Domain::Collection' ),
        shipments => ignore(),
        billing_address => ignore(),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'argument shipments data only' => sub {
    my $e = $pkg->new( { shipments => [ { shipping_items => [ {}, {} ] } ] } )->create_entity;
    $shipments->[0]->{shipping_items} =
      bless [ ( bless {}, 'Markets::Domain::Entity::Item' ), ( bless {}, 'Markets::Domain::Entity::Item' ) ],
      'Markets::Domain::Collection';
    cmp_deeply $e,
      bless {
        items     => ignore(),
        shipments => $shipments,
        billing_address => ignore(),
      },
      'Markets::Domain::Entity::Cart';
};

done_testing;
