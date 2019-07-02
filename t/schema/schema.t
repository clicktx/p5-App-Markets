use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

my $t      = Test::Mojo->new('App');
my $app    = $t->app;
my $schema = $app->schema;

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
        ok $schema->txn( sub { } ), 'right return value';
    }
    'right lives';
};

done_testing();
