use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;

my $pkg = 'Markets::Domain::Factory::Entity::Cart::Shipment';
use_ok $pkg;

subtest 'argument empty' => sub {
    my $factory = $pkg->new();
    my $entity  = $factory->create_entity();
    cmp_deeply $entity,
      bless {
        shipping_address => ( bless {}, 'Markets::Domain::Entity::Address' ),
        shipping_items => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart::Shipment';
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
        shipping_items => ( bless [ bless {}, 'Markets::Domain::Entity::Cart::Item', ], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart::Shipment';
};

done_testing;
