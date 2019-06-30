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

    my $dt = $pkg->new;
    is $dt->time_zone, 'UTC', 'right time zone';
    $dt->time_zone('Asia/Tokyo');
    is $dt->time_zone, 'Asia/Tokyo', 'right change time zone';
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
    isa_ok $dt->TZ, 'DateTime::TimeZone::UTC';

    $dt->time_zone('Asia/Tokyo');
    is ref $dt->TZ, 'DateTime::TimeZone::Asia::Tokyo', 'right change object';
};

done_testing();
