use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;
$ENV{MOJO_ADDON_TEST_MODE} = 1;

# Change your addon name //////////////////////// #
my $test_addon_name = 'Markets::Addon::Newpage';
#
# /////////////////////////////////////////////// #

my $t   = Test::Mojo->new('Markets');
my $app = $t->app;
t::Util->init_addon( $app, $test_addon_name, { is_enabled => 1 } );

subtest 'access check' => sub {
    $t->get_ok('/newpage')->status_is(200);
    $t->get_ok('/newpage/page')->status_is(200);
};

done_testing();
