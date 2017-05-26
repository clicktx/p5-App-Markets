use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;

subtest 'time zone' => sub {
    is ref $schema->TZ, 'DateTime::TimeZone::UTC', 'right object';
    is $schema->time_zone, 'UTC', 'right default time zone';

    $schema->time_zone('Asia/Tokyo');
    is ref $schema->TZ, 'DateTime::TimeZone::Asia::Tokyo', 'right change object';
    is $schema->time_zone, 'Asia/Tokyo', 'right change time zone';
};

subtest 'methods' => sub {
    ok $schema->now,   'right now()';
    ok $schema->today, 'right today()';
};

subtest 'sequence' => sub {
    my $cnt = $schema->sequence('Order');
    is $schema->sequence('Order'), $cnt + 1, 'right sequence';
    is $schema->sequence('order'), $cnt + 2, 'right sequence';
};

done_testing();
