use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

use_ok 'Markets::Model::Common';

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# my $model = Markets::Model::Common->new;
my $model = $app->model('common');

subtest 'dbic_txn_failed' => sub {
    my ( $err, $history );

    $err = 'error Rollback failed error';
    eval { $model->dbic_txn_failed($err) };
    $history = $app->error_log->history->[0];
    is $history->[1], 'fatal', 'right log level';
    is $history->[2], $err, 'right log message';
    like $@, qr/$err/, 'right died';

    $err = 'error message';
    eval { $model->dbic_txn_failed($err) };
    $history = $app->error_log->history->[1];
    is $history->[1], 'warn', 'right log level';
    is $history->[2], $err, 'right log message';
    is $@, '', 'right not died';
};

done_testing();
