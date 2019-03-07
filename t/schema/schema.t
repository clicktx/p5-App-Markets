use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

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

subtest 'txn_failed' => sub {
    my ( $err, $history );

    $err = 'error Rollback failed error';
    dies_ok { $schema->txn_failed($err) } 'right die';

    $history = $app->logging('error')->history->[-1];
    is $history->[1], 'fatal', 'right log level';
    is $history->[2], 'schema.rollback.failed', 'right log message';
    like $@, qr/$err/, 'right died';
};

subtest 'txn' => sub {
    dies_ok {
        $schema->txn( sub { die 'foo' } )
    }
    'right die';

    lives_ok {
        $schema->txn( sub { } )
    }
    'right lives';
};

done_testing();
