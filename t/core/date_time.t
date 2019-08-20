use Mojo::Base -strict;

use t::Util;
use Test::Mojo;
use Test::More;
my $pkg = 'Yetie::App::Core::DateTime';
use_ok $pkg;

subtest 'basic' => sub {
    my $t   = Test::Mojo->new('App');
    my $app = $t->app;
    isa_ok $app->date_time, $pkg;

    subtest 'time_zone' => sub {
        my $dt = $pkg->new;
        is $dt->time_zone, 'UTC', 'right default time zone';

        $dt = $pkg->new;
        $dt->time_zone('Asia/Tokyo');
        is $dt->time_zone, 'Asia/Tokyo', 'right change time zone';

        $dt = $pkg->new;
        $dt->time_zone('UTC');
        is $dt->time_zone, 'UTC', 'right revert time zone';
    };
};

subtest 'now' => sub {
    my $dt  = $pkg->new;
    my $now = $dt->now();
    isa_ok $now, 'DateTime';
};

subtest 'today' => sub {
    my $dt    = $pkg->new;
    my $today = $dt->today;
    isa_ok $today, 'DateTime';
};

subtest 'TZ' => sub {
    my $dt = $pkg->new;
    isa_ok $dt->TZ,  'DateTime::TimeZone::UTC', 'right from object';
    isa_ok $pkg->TZ, 'DateTime::TimeZone::UTC', 'right from package';

    $dt->time_zone('Asia/Tokyo');
    isa_ok $dt->TZ,  'DateTime::TimeZone::Asia::Tokyo', 'right from object';
    isa_ok $pkg->TZ, 'DateTime::TimeZone::Asia::Tokyo', 'right from package';

    $dt->time_zone('UTC');
};

done_testing();
