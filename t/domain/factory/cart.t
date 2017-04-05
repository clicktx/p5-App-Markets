use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Markets::Domain::Factory::Entity::Cart';
use_ok 'Markets::Domain::Factory::Entity::Cart';

subtest 'argument empty' => sub {
    my $e = $pkg->new->create_entity;
    cmp_deeply $e,
      bless {
        items => ( bless [], 'Markets::Domain::Collection' ),
        shipments => (
            bless [
                (
                    bless {
                        shipping_items => ( bless [], 'Markets::Domain::Collection' )
                    },
                    'Markets::Domain::Entity::Shipment'
                )
            ],
            'Markets::Domain::Collection'
        ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'shipments empty hash ref' => sub {
    my $e = $pkg->new( { shipments => [] } )->create_entity;
    cmp_deeply $e,
      bless {
        items     => ignore(),
        shipments => (
            bless [
                (
                    bless {
                        shipping_items => ( bless [], 'Markets::Domain::Collection' )
                    },
                    'Markets::Domain::Entity::Shipment'
                )
            ],
            'Markets::Domain::Collection'
        ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new()->create_entity;
    cmp_deeply $e, bless {
        items => ( bless [], 'Markets::Domain::Collection' ),

        # shipments => ( bless [ bless {}, 'Markets::Domain::Entity::Shipment' ], 'Markets::Domain::Collection' ),
        shipments => ignore(),
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
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'argument shipments data only' => sub {
    my $e = $pkg->new( { shipments => [ { shipping_items => [ {}, {} ] } ] } )->create_entity;

    cmp_deeply $e,
      bless {
        items     => ignore(),
        shipments => (
            bless [
                (
                    bless {
                        shipping_items => (
                            bless [
                                ( bless {}, 'Markets::Domain::Entity::Item' ),
                                ( bless {}, 'Markets::Domain::Entity::Item' )
                            ],
                            'Markets::Domain::Collection'
                        )
                    },
                    'Markets::Domain::Entity::Shipment'
                )
            ],
            'Markets::Domain::Collection'
        ),
      },
      'Markets::Domain::Entity::Cart';
};

done_testing;
