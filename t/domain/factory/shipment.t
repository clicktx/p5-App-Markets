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
      bless { shipping_items => ( bless [], 'Markets::Domain::Collection' ) },
      'Markets::Domain::Entity::Shipment';
};

done_testing;
