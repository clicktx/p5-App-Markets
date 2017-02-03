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

    # uploaded
    my $uploded_addons = $app->addons->uploaded->to_array;
    is ref $uploded_addons, 'ARRAY', 'return array ref';
    is @{$uploded_addons}, 3, 'right all addons';
    my @sort_array =
      sort { $a cmp $b } @{$uploded_addons};    # Hack: OSによる違いに対処
    is_deeply \@sort_array,
      [
        'Markets::Addon::DisableAddon', 'Markets::Addon::NotInstallAddon',
        'Markets::Addon::TestAddon'
      ],
      'right all addons';

    # installed
    is ref $app->addons->installed, 'HASH', 'right installed method';
    is ref $app->addons->addon,     'HASH', 'right addon method';

    # Get addon object
    my $addon = $app->addons->addon('Markets::Addon::TestAddon');
    ok( defined $addon && $addon->isa('Markets::Addon') ), 'right addon($addon_name)';

    # Set addon object
    my $new_addon = Markets::Addon::TestAddon->new;
    $app->addons->addon( new_addon => $new_addon );
    is ref $app->addons->addon('new_addon'), 'Markets::Addon::TestAddon', 'right set addon';
};

subtest 'addon basic' => sub {
    my $addon = Markets::Addon::TestAddon->new;
    is $addon->class_name, 'Markets::Addon::TestAddon', 'right class name';
    is $addon->addon_name, 'TestAddon', 'right addon name';

    # enable/disable
    $addon->is_enabled(1);
    ok $addon->is_enabled, 'right addon is enabled';
    $addon->is_enabled(0);
    ok !$addon->is_enabled, 'right addon is desabled';
};

subtest 'load addon' => sub {
    my $addon;
    eval { my $addon = $app->addons->load_addon("Markets::Addon::NotFoundAddon") };
    is $@, 'Addon "Markets::Addon::NotFoundAddon" missing, maybe you need to upload it?' . "\n";
    is $addon, undef, "don't load addon";
};

subtest 'for t/addons TestAddon' => sub {

    # Hooks
    my $test_action = $app->action_hook->subscribers('action_example_hook');
    my $test_filter = $app->filter_hook->subscribers('filter_example_hook');

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
    my $addon = $app->addons->{installed}->{'Markets::Addon::TestAddon'};
    $app->addons->to_disable($addon);

    $test_action = $app->action_hook->subscribers('action_example_hook');
    $test_filter = $app->filter_hook->subscribers('filter_example_hook');
    is_deeply $test_action, [], 'removed action hooks';
    is_deeply $test_filter, [], 'removed action hooks';
    $t->get_ok('/test_addon')->status_is(404);
    $t->get_ok('/test_addon/hoo')->status_is(404);
};

subtest 'for t/addons DisableAddon' => sub {
    my $disable_action = $app->action_hook->subscribers('action_disable_hook');
    my $disable_filter = $app->filter_hook->subscribers('filter_disable_hook');
    is_deeply $disable_action, [], 'no action hooks';
    is_deeply $disable_filter, [], 'no filter hooks';
    $t->get_ok('/disable_addon')->status_is(404);
};

done_testing();
