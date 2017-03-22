use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use t::Util;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Markets::Domain::Factory::Entity::Cart';
ok $app->factory(
    'entity-cart',
    {
        cart_id   => undef,
        cart_data => undef,
    }
  ),
  'argument empty';

ok $app->factory(
    'entity-cart',
    {
        cart_id   => '',
        cart_data => { items => [ [ {} ] ] }
    }
  ),
  'argument items data only';

done_testing();
