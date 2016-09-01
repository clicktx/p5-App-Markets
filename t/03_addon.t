use Mojo::Base -strict;
use lib 't/lib';

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t   = Test::Mojo->new('Markets::Web');
my $app = $t->app;

my $addon_settings = {
    'Markets::Addon::TestAddon' => {
        is_enabled => 1,
        hooks      => [],
        config     => {},
    },
};

# Re-initialize of the addon.
$app->addons->init($addon_settings);

subtest 'basic' => sub {
    my $addon = $app->addons->load_addon('Markets::Addon::TestAddon');
    is $addon->class_name, 'Markets::Addon::TestAddon', 'right class name';
    is $addon->addon_name, 'TestAddon', 'right addon name';
    my $r = $addon->routes;
    is $r->name, 'Markets::Addon::TestAddon', 'right routes name';
};

subtest 'load addon' => sub {
    eval { $app->addon("NotFoundAddon") };
    is $@,
      'Addon "NotFoundAddon" missing, maybe you need to install it?' . "\n";

    $app->addons->init;

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
};

done_testing();
