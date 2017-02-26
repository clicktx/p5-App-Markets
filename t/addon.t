use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $r   = $app->routes->namespaces( ['Markets::Controller'] );
$r->find('RN_category_name_base')->remove;    # Hack for name base category

subtest 'addons basic' => sub {
    my $addons = $app->addons;

    # uploaded
    my $uploded_addons = $addons->uploaded->sort->to_array;
    is ref $uploded_addons, 'ARRAY', 'return array ref';
    is @{$uploded_addons}, 3, 'right uploaded addons';
    is_deeply $uploded_addons, [ 'disable_addon', 'not_install_addon', 'test_addon' ],
      'right uploaded addons';

    # installed
    is ref $addons->installed, 'HASH', 'right installed method';
    is ref $addons->addon,     'HASH', 'right addon method';

    # Get addon object
    my $addon = $addons->addon('Markets::Addon::TestAddon');
    ok( defined $addon && $addon->isa('Markets::Addon') ), 'right addon($addon_name)';
    is ref $addons->addon('Markets::Addon::TestAddon'), 'Markets::Addon::TestAddon',
      'access full module name';
    is ref $addons->addon('TestAddon'),  'Markets::Addon::TestAddon', 'access camel case';
    is ref $addons->addon('test_addon'), 'Markets::Addon::TestAddon', 'access snake case';

    # Set addon object
    $addons->addon( 'Markets::Addon::FirstAddon' => Markets::Addon::TestAddon->new );
    is ref $addons->addon('first_addon'), 'Markets::Addon::TestAddon', 'set addon full module name';
    $addons->addon( SecondAddon => Markets::Addon::TestAddon->new );
    is ref $addons->addon('second_addon'), 'Markets::Addon::TestAddon', 'set addon camel case';
    $addons->addon( third_addon => Markets::Addon::TestAddon->new );
    is ref $addons->addon('third_addon'), 'Markets::Addon::TestAddon', 'set addon snake case';

    subtest 'load addon' => sub {

        #_full_module_name
        is Markets::Addons::_full_module_name('Markets::Addon::MyAddon'), 'Markets::Addon::MyAddon';
        is Markets::Addons::_full_module_name('MyAddon'),                 'Markets::Addon::MyAddon';
        is Markets::Addons::_full_module_name('my_addon'),                'Markets::Addon::MyAddon';

        is ref $addons->load_addon("Markets::Addon::TestAddon"), 'Markets::Addon::TestAddon';
        is ref $addons->load_addon("TestAddon"),                 'Markets::Addon::TestAddon';
        is ref $addons->load_addon("test_addon"),                'Markets::Addon::TestAddon';

        my $not_found_addon;
        eval { $not_found_addon = $addons->load_addon("NotFoundAddon") };
        is $@, 'Addon "NotFoundAddon" missing, maybe you need to upload it?' . "\n";

        # Full module name
        eval { $not_found_addon = $addons->load_addon("Markets::Addon::NotFoundAddon") };
        is $@, 'Addon "Markets::Addon::NotFoundAddon" missing, maybe you need to upload it?' . "\n";
        is $not_found_addon, undef, "don't load addon";
    };
};

subtest 'addon basic' => sub {
    my $addon = Markets::Addon::TestAddon->new;
    is $addon->class_name, 'Markets::Addon::TestAddon', 'right class name';
    is $addon->name, 'test_addon', 'right addon name';

    # enable/disable
    $addon->is_enabled(1);
    ok $addon->is_enabled, 'right addon is enabled';
    $addon->is_enabled(0);
    ok !$addon->is_enabled, 'right addon is desabled';
};

subtest 'for t/addons TestAddon' => sub {

    # Hooks
    my $test_action = $app->addons->action_hook->subscribers('action_example_hook');
    my $test_filter = $app->addons->filter_hook->subscribers('filter_example_hook');

    is $test_action->[0]->{priority}, 100, 'right priority, action hook';
    is $test_action->[1]->{priority}, 500, 'right priority, action hook';
    is ref $test_action->[0]->{cb}, 'CODE', 'right code ref, action hook';

    is $test_filter->[0]->{priority}, 10,  'right priority, filter hook';
    is $test_filter->[1]->{priority}, 100, 'right priority, filter hook';
    is ref $test_filter->[0]->{cb}, 'CODE', 'right code ref, filter hook';

    # Routes
    $t->get_ok('/test_addon')->status_is(200)->content_like(qr/top/);
    $t->get_ok('/test_addon/hoo')->status_is(200)->content_like(qr/hoo/);
    $t->get_ok('/test_addon/nooo')->status_is(404);

    # Change disable addon
    my $addons = $app->addons;
    my $addon  = $addons->addon('Markets::Addon::TestAddon');
    $addons->to_disable($addon);

    $test_action = $app->addons->action_hook->subscribers('action_example_hook');
    $test_filter = $app->addons->filter_hook->subscribers('filter_example_hook');
    is_deeply $test_action, [], 'removed action hooks';
    is_deeply $test_filter, [], 'removed action hooks';
    $t->get_ok('/test_addon')->status_is(404);
    $t->get_ok('/test_addon/hoo')->status_is(404);
};

subtest 'for t/addons DisableAddon' => sub {
    my $disable_action = $app->addons->action_hook->subscribers('action_disable_hook');
    my $disable_filter = $app->addons->filter_hook->subscribers('filter_disable_hook');
    is_deeply $disable_action, [], 'no action hooks';
    is_deeply $disable_filter, [], 'no filter hooks';
    $t->get_ok('/disable_addon')->status_is(404);
};

done_testing();
