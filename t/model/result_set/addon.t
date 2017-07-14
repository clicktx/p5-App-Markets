use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Markets::Schema::ResultSet::Addon';

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $rs  = $app->schema->resultset('addon');

is_deeply $rs->configure,
  {
    disable_addon => {
        is_enabled => 0,
        triggers   => [],
    },
    test_addon => {
        is_enabled => 1,
        triggers   => [],
    },
  },
  'right configure';

done_testing();
