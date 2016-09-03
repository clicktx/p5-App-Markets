use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $addon_settings = {
    'Markets::Addon::TestAddon' => {
        is_enabled => 1,

        # routes     => '',
        hooks  => [],
        config => {},
    },
    'Markets::Addon::DisableAddon' => {
        is_enabled => 0,

        # routes     => '',
        hooks  => [],
        config => {},
    },
};

# Re-initialize of the addon.
$app->addons->init($addon_settings);

subtest 'basic' => sub {
    is_deeply $app->all_addons, [ 'DisableAddon', 'NotInstallAddon', 'TestAddon' ],
      'right all addons';
    my $addon = $app->addons->load_addon('Markets::Addon::TestAddon');
    is $addon->class_name, 'Markets::Addon::TestAddon', 'right class name';
    is $addon->addon_name, 'TestAddon', 'right addon name';
    my $r = $addon->routes;
    is $r->name, 'Markets::Addon::TestAddon', 'right routes name';
};

subtest 'load addon' => sub {
    eval { $app->register_addon("NotFoundAddon") };
    is $@,
      'Addon "NotFoundAddon" missing, maybe you need to install it?' . "\n";

    $app->addons->init;
};

subtest 'for TestAddon' => sub {

    # my $test_action = $app->action->{events}->{action_exsample_hook};
    # my $test_filter = $app->filter->{events}->{filter_exsample_hook};
    my $test_action = $app->action->subscribers('action_exsample_hook');
    my $test_filter = $app->filter->subscribers('filter_exsample_hook');

    is $test_action->[0]->{priority}, 100, 'right priority, action hook';
    is $test_action->[1]->{priority}, 500, 'right priority, action hook';
    is ref $test_action->[0]->{cb}, 'CODE', 'right code ref, action hook';

    is $test_filter->[0]->{priority}, 10,  'right priority, filter hook';
    is $test_filter->[1]->{priority}, 100, 'right priority, filter hook';
    is ref $test_filter->[0]->{cb}, 'CODE', 'right code ref, filter hook';

    $t->get_ok('/test_addon')->status_is(200)->content_like(qr/top/);
    $t->get_ok('/test_addon/hoo')->status_is(200)->content_like(qr/hoo/);
    $t->get_ok('/test_addon/nooo')->status_is(404);
};

subtest 'for DisableAddon' => sub {
    my $disable_action = $app->action->subscribers('action_disable_hook');
    my $disable_filter = $app->filter->subscribers('filter_disable_hook');
    is_deeply $disable_action, [], 'no action hooks';
    is_deeply $disable_filter, [], 'no filter hooks';

    $t->get_ok('/disable_addon')->status_is(404);
};

done_testing();
