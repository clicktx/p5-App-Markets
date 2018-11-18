use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('authorization_request');
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

subtest 'validate_token' => sub {
    my ( $c, $s ) = _init();

    my $res;
    my $rs     = $c->resultset('AuthorizationRequest');
    my $email  = 'foo@bar.baz';
    my $token1 = $s->generate_token($email);

    # hack expired
    my $expires = time - 3600;
    $rs->find( { token => $token1 } )->update( { expires => $expires } );
    $res = $s->validate_token($token1);
    ok !$res, 'right expired';

    my $token2 = $s->generate_token($email);
    my $token3 = $s->generate_token($email);
    $res = $s->validate_token('tokenfoobarbaz');
    ok !$res, 'right not found token';

    $res = $s->validate_token($token2);
    ok !$res, 'right not last request';

    $res = $s->validate_token($token3);
    ok $res, 'right first validation';
    $res = $s->validate_token($token3);
    ok !$res, 'right second validation';
};

done_testing();
