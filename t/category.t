use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $schema  = $app->schema;

ok 1;

done_testing();
