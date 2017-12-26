use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Yetie::Domain::Factory';
use_ok 'Yetie::Domain::Factory::Shipment';

subtest 'argument empty' => sub {
    my $factory = $pkg->new('entity-shipment');
    my $entity  = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless {}, 'Yetie::Domain::Entity::Address' ),
        items => ( bless [], 'Yetie::Domain::Collection' ),
      },
      'Yetie::Domain::Entity::Shipment';
};

subtest 'data' => sub {
    my $factory = $pkg->new(
        'entity-shipment',
        {
            shipping_address => { line1 => 'Silicon Valley' },
            items            => [       {} ],
        }
    );
    my $entity = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless { line1 => 'Silicon Valley' }, 'Yetie::Domain::Entity::Address' ),
        items => ( bless [ bless {}, 'Yetie::Domain::Entity::Cart::Item', ], 'Yetie::Domain::Collection' ),
      },
      'Yetie::Domain::Entity::Shipment';
};

done_testing;
