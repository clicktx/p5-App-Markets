use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Markets::Domain::Factory::Entity::Shipment';
use_ok $pkg;

subtest 'argument empty' => sub {
    my $factory = $pkg->new();
    my $entity  = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless {}, 'Markets::Domain::Entity::Address' ),
        shipping_items => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Shipment';
};

subtest 'data' => sub {
    my $factory = $pkg->new(
        {
            shipping_address => { line1 => 'Silicon Valley' },
            shipping_items   => [       {} ],
        }
    );
    my $entity = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless { line1 => 'Silicon Valley' }, 'Markets::Domain::Entity::Address' ),
        shipping_items => ( bless [ bless {}, 'Markets::Domain::Entity::SellingItem', ], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Shipment';
};

done_testing;
