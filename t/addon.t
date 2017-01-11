use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'basic' => sub {

    my $all_addons = $app->addons->get_all;
    is ref $all_addons, 'ARRAY', 'return array ref';
    is @{$all_addons}, 3, 'right all addons';
    my @sort_array =
      sort { $a cmp $b } @{$all_addons};    # Hack: OSによる違いに対処
    is_deeply \@sort_array,
      [
        'Markets::Addon::DisableAddon', 'Markets::Addon::NotInstallAddon',
        'Markets::Addon::TestAddon'
      ],
      'right all addons';

    my $addon = Markets::Addon::TestAddon->new;
    is $addon->class_name, 'Markets::Addon::TestAddon', 'right class name';
    is $addon->addon_name, 'TestAddon', 'right addon name';
};

subtest 'load addon' => sub {
    eval { $app->register_addon("NotFoundAddon") };
    is $@, 'Addon "NotFoundAddon" missing, maybe you need to install it?' . "\n";
};

subtest 'for TestAddon' => sub {

    # Hooks
    # my $test_action = $app->action_hook->{events}->{action_example_hook};
    # my $test_filter = $app->filter_hook->{events}->{filter_example_hook};
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

    # Disable addon
    $app->addons->to_disable('Markets::Addon::TestAddon');
    $test_action = $app->action_hook->subscribers('action_example_hook');
    $test_filter = $app->filter_hook->subscribers('filter_example_hook');
    is_deeply $test_action, [], 'removed action hooks';
    is_deeply $test_filter, [], 'removed action hooks';
    # $t->get_ok('/test_addon')->status_is(404);
    $t->get_ok('/test_addon')->status_is(200)->content_like(qr/category/i);  # category扱いになるため
    $t->get_ok('/test_addon/hoo')->status_is(404);

};

subtest 'for DisableAddon' => sub {
    my $disable_action = $app->action_hook->subscribers('action_disable_hook');
    my $disable_filter = $app->filter_hook->subscribers('filter_disable_hook');
    is_deeply $disable_action, [], 'no action hooks';
    is_deeply $disable_filter, [], 'no filter hooks';

    # $t->get_ok('/disable_addon')->status_is(404);
    $t->get_ok('/disable_addon')->status_is(200)->content_like(qr/category/i);  # category扱いになるため
};

done_testing();
