use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

subtest 'remove session' => sub {
    my $schema  = $app->schema;
    my $rs      = $schema->resultset('Session');
    my $cnt     = $rs->count;
    my $session = t::Util::server_session($app);

    $session->create;
    $session->flush;
    is $rs->count - $cnt, 1, 'right session count';

    # remove session
    my $bool = $app->model('account')->remove_session($session);
    $session->flush;

    is $bool, 1, 'remove session';
    is $rs->count - $cnt, 0, 'right count';

    $bool = $app->model('account')->remove_session($session);
    $session->flush;
    is $bool, 0, 'duplicate remove session';
    is $rs->count - $cnt, 0, 'right count';
};

done_testing();
