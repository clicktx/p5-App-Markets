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
        items     => ( bless [], 'Markets::Domain::Collection' ),
        shipments => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'cart data empty' => sub {
    my $e = $pkg->new(
        {
            cart_id   => undef,
            cart_data => undef,
        }
    )->create_entity;
    cmp_deeply $e,
      bless {
        cart_id   => undef,
        items     => ( bless [], 'Markets::Domain::Collection' ),
        shipments => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'argument items data only' => sub {
    my $e = $pkg->new(
        {
            cart_id   => '',
            cart_data => { items => [ {} ] }
        }
    )->create_entity;
    cmp_deeply $e,
      bless {
        cart_id => '',
        items   => (
            bless [ ( bless {}, 'Markets::Domain::Entity::Item' ) ], 'Markets::Domain::Collection'
        ),
        shipments => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart';
};

done_testing;
