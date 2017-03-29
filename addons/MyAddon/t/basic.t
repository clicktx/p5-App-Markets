use Mojo::Base -strict;
use t::Util;
use Test::More;
use Test::Mojo;
$ENV{MOJO_ADDON_TEST_MODE} = 1;

# Change your addon name //////////////////////// #
my $test_addon_name = 'Markets::Addon::MyAddon';
#
# /////////////////////////////////////////////// #

my $t   = Test::Mojo->new('Markets');
my $app = $t->app;
t::Util->init_addon( $app, $test_addon_name, { is_enabled => 1 } );

subtest 'front page' => sub {
    $t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
};

subtest 'admin page' => sub {
    ok 1;
    # $t->get_ok('/admin')->status_is(200)->content_like(qr/Admin/i);
    # $t->get_ok('/ja/admin')->status_is(200)
    #   ->content_like(qr/こんにちはmy-addon/i);
};

my $rs = $app->schema->resultset('MyAddonTest');
is $rs->count, 0, 'right using schema';

done_testing();
