use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;
$ENV{MOJO_ADDON_TEST_MODE} = 1;

# Change your addon name //////////////////////// #
my $test_addon_name = 'Markets::Addon::DefaultFilters';
#
# /////////////////////////////////////////////// #

my $t   = Test::Mojo->new('Markets');
my $app = $t->app;
t::Util->init_addon( $app, $test_addon_name, { is_enabled => 1 } );

$t->get_ok('/')->status_is(200)->;


done_testing();
