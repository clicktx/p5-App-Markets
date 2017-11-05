use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Yetie::Domain::Factory';
use_ok 'Yetie::Domain::Factory::Entity::Shipment';

subtest 'argument empty' => sub {
    my $factory = $pkg->new('entity-shipment');
    my $entity  = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless {}, 'Yetie::Domain::Entity::Address' ),
        shipping_items => ( bless [], 'Yetie::Domain::Collection' ),
      },
      'Yetie::Domain::Entity::Shipment';
};

subtest 'data' => sub {
    my $factory = $pkg->new(
        'entity-shipment',
        {
            shipping_address => { line1 => 'Silicon Valley' },
            shipping_items   => [       {} ],
        }
    );
    my $entity = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless { line1 => 'Silicon Valley' }, 'Yetie::Domain::Entity::Address' ),
        shipping_items =>
          ( bless [ bless {}, 'Yetie::Domain::Entity::SellingItem', ], 'Yetie::Domain::Collection' ),
      },
      'Yetie::Domain::Entity::Shipment';
};

done_testing;
