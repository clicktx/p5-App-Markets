use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t   = Test::Mojo->new('App');
my $app = $t->app;
my $r   = $app->routes->namespaces( ['Yetie::Controller'] );

subtest 'addons basic' => sub {
    my $addons = $app->addons;

    # uploaded
    my $uploded_addons = $addons->uploaded->sort->to_array;
    is ref $uploded_addons, 'ARRAY', 'return array ref';
    is @{$uploded_addons}, 3, 'right uploaded addons';
    is_deeply $uploded_addons, [ 'disable_addon', 'not_install_addon', 'test_addon' ], 'right uploaded addons';

    # installed
    is ref $addons->installed, 'HASH', 'right installed method';
    is ref $addons->addon,     'HASH', 'right addon method';

    # Get addon object
    my $addon = $addons->addon('Yetie::Addon::TestAddon');
    ok defined $addon, 'right addon method';
    isa_ok $addon, 'Yetie::Addon::Base';

    is ref $addons->addon('Yetie::Addon::TestAddon'), 'Yetie::Addon::TestAddon', 'access full module name';
    is ref $addons->addon('TestAddon'),                 'Yetie::Addon::TestAddon', 'access camel case';
    is ref $addons->addon('test_addon'),                'Yetie::Addon::TestAddon', 'access snake case';

    # Set addon object
    $addons->addon( 'Yetie::Addon::FirstAddon' => Yetie::Addon::TestAddon->new );
    is ref $addons->addon('first_addon'), 'Yetie::Addon::TestAddon', 'set addon full module name';
    $addons->addon( SecondAddon => Yetie::Addon::TestAddon->new );
    is ref $addons->addon('second_addon'), 'Yetie::Addon::TestAddon', 'set addon camel case';
    $addons->addon( third_addon => Yetie::Addon::TestAddon->new );
    is ref $addons->addon('third_addon'), 'Yetie::Addon::TestAddon', 'set addon snake case';

    subtest 'load addon' => sub {

        #_full_module_name
        is Yetie::Addon::Handler::_full_module_name('Yetie::Addon::MyAddon'), 'Yetie::Addon::MyAddon';
        is Yetie::Addon::Handler::_full_module_name('MyAddon'),                 'Yetie::Addon::MyAddon';
        is Yetie::Addon::Handler::_full_module_name('my_addon'),                'Yetie::Addon::MyAddon';

        is ref $addons->load_addon("Yetie::Addon::TestAddon"), 'Yetie::Addon::TestAddon';
        is ref $addons->load_addon("TestAddon"),                 'Yetie::Addon::TestAddon';
        is ref $addons->load_addon("test_addon"),                'Yetie::Addon::TestAddon';

        my $not_found_addon;
        eval { $not_found_addon = $addons->load_addon("NotFoundAddon") };
        is $@, 'Addon "NotFoundAddon" missing, maybe you need to upload it?' . "\n";

        # Full module name
        eval { $not_found_addon = $addons->load_addon("Yetie::Addon::NotFoundAddon") };
        is $@, 'Addon "Yetie::Addon::NotFoundAddon" missing, maybe you need to upload it?' . "\n";
        is $not_found_addon, undef, "don't load addon";
    };
};

subtest 'addon basic' => sub {
    my $addon = Yetie::Addon::TestAddon->new;
    is $addon->class_name, 'Yetie::Addon::TestAddon', 'right class name';
    is $addon->name, 'test_addon', 'right addon name';

    # enable/disable
    $addon->is_enabled(1);
    ok $addon->is_enabled, 'right addon is enabled';
    $addon->is_enabled(0);
    ok !$addon->is_enabled, 'right addon is desabled';
};

subtest 'for t/addons TestAddon' => sub {

    # Triggers
    my $test_action = $app->addons->trigger->subscribers('action_example_trigger');
    my $test_filter = $app->addons->trigger->subscribers('filter_example_trigger');

    is $test_action->[0]->{priority}, 100, 'right priority, action trigger';
    is $test_action->[1]->{priority}, 500, 'right priority, action trigger';
    is ref $test_action->[0]->{cb}, 'CODE', 'right code ref, action trigger';

    is $test_filter->[0]->{priority}, 10,  'right priority, filter trigger';
    is $test_filter->[1]->{priority}, 100, 'right priority, filter trigger';
    is ref $test_filter->[0]->{cb}, 'CODE', 'right code ref, filter trigger';

    # Routes
    $t->get_ok('/test_addon')->status_is(200)->content_like(qr/top/);
    $t->get_ok('/test_addon/hoo')->status_is(200)->content_like(qr/hoo/);
    $t->get_ok('/test_addon/nooo')->status_is(404);

    # Change status to disable
    my $addons = $app->addons;
    my $addon  = $addons->addon('Yetie::Addon::TestAddon');
    $addons->to_disable($addon);

    $test_action = $app->addons->trigger->subscribers('action_example_trigger');
    $test_filter = $app->addons->trigger->subscribers('filter_example_trigger');
    is_deeply $test_action, [], 'removed action triggers';
    is_deeply $test_filter, [], 'removed action triggers';
    $t->get_ok('/test_addon')->status_is(404);
    $t->get_ok('/test_addon/hoo')->status_is(404);
};

subtest 'for t/addons DisableAddon' => sub {
    my $disable_action = $app->addons->trigger->subscribers('action_disable_trigger');
    my $disable_filter = $app->addons->trigger->subscribers('filter_disable_trigger');
    is_deeply $disable_action, [], 'no action triggers';
    is_deeply $disable_filter, [], 'no filter triggers';
    $t->get_ok('/disable_addon')->status_is(404);
};

done_testing();
