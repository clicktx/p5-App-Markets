use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;

subtest 'time zone' => sub {
    is ref $schema->TZ, 'DateTime::TimeZone::America::Los_Angeles', 'right object';
    is $schema->time_zone, 'America/Los_Angeles', 'right default time zone';

    $schema->time_zone('Asia/Tokyo');
    is ref $schema->TZ, 'DateTime::TimeZone::Asia::Tokyo', 'right change object';
    is $schema->time_zone, 'Asia/Tokyo', 'right change time zone';
};

subtest 'methods' => sub {
    ok $schema->now, 'right now()';
    ok $schema->today, 'right today()';
};

subtest 'sequence' => sub {
    is $schema->sequence('Order'), 1, 'right sequence';
    is $schema->sequence('order'), 2, 'right sequence';
};

done_testing();
