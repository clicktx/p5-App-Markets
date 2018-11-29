use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('authorization');
    return ( $controller, $service );
}

subtest 'generate_token' => sub {
    my ( $c, $s ) = _init();
    my $rs      = $c->resultset('AuthorizationRequest');
    my $last_id = $rs->last_id;

    my $r = qr/[0-9A-F]/;
    like $s->generate_token('foo@example.org'), qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right token';
    isnt $last_id, $rs->last_id, 'right store to DB';
};

subtest 'find' => sub {
    my ( $c, $s ) = _init();

    my $rs    = $c->resultset('AuthorizationRequest');
    my $email = 'foo@bar.baz';
    my $token = $s->generate_token($email);

    my $auth = $s->find($token);
    ok $auth, 'right find token';

    $auth = $s->find('foobar');
    ok !$auth, 'right not found token';
    like $c->logging->history->[-1]->[2], qr/Not found token/, 'right logging';
};

subtest 'validate' => sub {
    my ( $c, $s ) = _init();

    my $res;
    my $rs     = $c->resultset('AuthorizationRequest');
    my $email  = 'foo@bar.baz';
    my $token1 = $s->generate_token($email);

    # Hack expired
    my $expires = time - 3600;
    $rs->find( { token => $token1 } )->update( { expires => $expires } );
    my $auth = $s->find($token1);
    $res = $s->validate($auth);
    ok !$res, 'right expired';

    # Hack email
    $auth->email( $s->factory('value-email')->construct( value => 'a@b.com' ) );
    $res = $s->validate($auth);
    ok !$res, 'right not found last request';
    like $c->logging->history->[-1]->[2], qr/Not found last request/, 'right logging';

    my $token2 = $s->generate_token($email);
    my $token3 = $s->generate_token($email);
    $auth = $s->find($token2);
    $res  = $s->validate($auth);
    ok !$res, 'right not last request';

    $auth = $s->find($token3);
    $res  = $s->validate($auth);
    ok $res, 'right first validation';

    $auth = $s->find($token3);
    $res  = $s->validate($auth);
    ok !$res, 'right second validation';
};

done_testing();
