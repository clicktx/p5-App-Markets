use Mojo::Base -strict;
use lib 't/lib';

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t   = Test::Mojo->new('Markets::Web');
my $app = $t->app;

subtest 'load addon' => sub {
    $app->addon("TestAddon");
    # my $test_action = $app->actions->{events}->{action_exsample_hook};
    # my $test_filter = $app->filters->{events}->{filter_exsample_hook};
    my $test_action = $app->actions->subscribers('action_exsample_hook');
    my $test_filter = $app->filters->subscribers('filter_exsample_hook');

    is $test_action->[0]->{priority}, 500, 'right priority, action hook';
    is ref $test_action->[0]->{cb}, 'CODE', 'right code ref, action hook';

    is $test_filter->[0]->{priority}, 10, 'right priority, filter hook';
    is ref $test_filter->[0]->{cb}, 'CODE', 'right code ref, filter hook';
};

done_testing();
