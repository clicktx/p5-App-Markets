use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;
use t::Util;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Markets::Domain::Factory::Entity::Cart';

subtest 'argument empty' => sub {
    my $e = $app->factory('entity-cart');
    cmp_deeply $e,
      bless {
        items     => ( bless [], 'Markets::Domain::Collection' ),
        shipments => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'cart data empty' => sub {
    my $e = $app->factory(
        'entity-cart',
        {
            cart_id   => undef,
            cart_data => undef,
        }
    );
    cmp_deeply $e,
      bless {
        cart_id   => undef,
        items     => ( bless [], 'Markets::Domain::Collection' ),
        shipments => ( bless [], 'Markets::Domain::Collection' ),
      },
      'Markets::Domain::Entity::Cart';
};

subtest 'argument items data only' => sub {
    my $e = $app->factory(
        'entity-cart',
        {
            cart_id   => '',
            cart_data => { items => [ {} ] }
        }
    );
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
