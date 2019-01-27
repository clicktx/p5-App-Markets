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
    my $token = $s->generate_token( 'foo@example.org', { redirect => 'foo' } );
    like $token, qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right token';
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
    is $c->logging->history->[-1]->[1], 'warn', 'right logging';
};

subtest 'validate' => sub {
    my ( $c, $s ) = _init();

    my $res;
    my $email = 'foo@bar.baz';

    # Hack expired
    my $token1  = $s->generate_token($email);
    my $expires = time - 3600;
    $c->resultset('AuthorizationRequest')->find( { token => $token1 } )->update( { expires => $expires } );
    $res = $s->validate($token1);
    ok !$res->is_valid, 'right expired';
    is $c->logging->history->[-1]->[1], 'warn', 'right logging';

    my $token2 = $s->generate_token($email);
    my $token3 = $s->generate_token($email);
    $res = $s->validate($token2);
    ok !$res->is_valid, 'right not last request';

    $res = $s->validate($token3);
    ok $res->is_valid, 'right first validation';
    is $res->email, $email, 'right request email';

    $res = $s->validate($token3);
    ok !$res->is_valid, 'right second validation';
};

done_testing();
