use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('authentication');
    return ( $controller, $service );
}

subtest 'create_token' => sub {
    my ( $c, $s ) = _init();
    my $rs      = $c->resultset('AuthenticationRequest');
    my $last_id = $rs->last_id;

    my $r = qr/[0-9A-F]/;
    my $token = $s->create_token( 'foo@example.org', { continue_url => 'foo' } );
    like $token->value, qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right token';
    isnt $last_id, $rs->last_id, 'right store to DB';
};

subtest 'find_request' => sub {
    my ( $c, $s ) = _init();

    my $rs    = $c->resultset('AuthenticationRequest');
    my $email = 'foo@bar.baz';
    my $token = $s->create_token($email);

    my $auth = $s->find_request( $token->value );
    ok $auth, 'right find request';

    $auth = $s->find_request('foobar');
    ok !$auth, 'right not found request';
    is $c->logging->history->[-1]->[1], 'warn', 'right logging';
};

subtest 'verify' => sub {
    my ( $c, $s ) = _init();

    my $res;
    my $email = 'foo@bar.baz';

    # Hack expired
    my $token1  = $s->create_token($email);
    my $expires = time - 3600;
    $c->resultset('AuthenticationRequest')->find( { token => $token1->value } )->update( { expires => $expires } );
    $res = $s->verify($token1);
    ok !$res->is_verified, 'right expired';
    is $c->logging->history->[-1]->[1], 'warn', 'right logging';

    my $token2 = $s->create_token($email);
    my $token3 = $s->create_token($email);
    $res = $s->verify( $token2->value );
    ok !$res->is_verified, 'right not last request';

    $res = $s->verify( $token3->value );
    ok $res->is_verified, 'right first verify';
    is $res->email->value, $email, 'right request email';

    $res = $s->verify( $token3->value );
    ok !$res->is_verified, 'right second verify';
};

done_testing();
