use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Test::Exception;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

sub _init {
    my $controller = $app->build_controller;
    my $service    = $controller->service('authentication');
    return ( $controller, $service );
}

subtest 'create_magic_link' => sub {
    my ( $c, $s ) = _init();

    my $url = $s->create_magic_link(
        {
            email        => 'foo@example.org',
            action       => 'bar',
            continue_url => 'baz',
            expires      => 112233,
        }
    );
    isa_ok $url, 'Mojo::URL';
    like $url->to_string, qr{/magic-link/*.}, 'right default path';

    $url = $s->create_magic_link(
        {
            email  => 'foo@example.org',
            action => 'bar',
            route  => 'rn.auth.magic_link.signup',
        }
    );
    like $url->to_string, qr{/get-started/*.}, 'right change path';
};

subtest 'create_token' => sub {
    my ( $c, $s ) = _init();
    my $rs      = $c->resultset('AuthenticationRequest');
    my $last_id = $rs->last_id;

    dies_ok { $s->create_token( 'foo@example.org', {} ) }, 'right not set action value';

    my $r = qr/[0-9A-F]/;
    my $token = $s->create_token( 'foo@example.org', { action => 'foo', continue_url => 'bar' } );
    like $token->value, qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right token';
    isnt $last_id, $rs->last_id, 'right store to DB';
};

subtest 'find_request' => sub {
    my ( $c, $s ) = _init();

    my $rs    = $c->resultset('AuthenticationRequest');
    my $email = 'foo@bar.baz';
    my $token = $s->create_token( $email, { action => 'foo' } );

    my $auth = $s->find_request( $token->value );
    ok $auth, 'right find request';

    $auth = $s->find_request('foobar');
    ok !$auth, 'right not found request';
    is $c->logging->history->[-1]->[1], 'warn', 'right logging';
};

subtest 'remember_token' => sub {
    my ( $c, $s ) = _init();

    ok !$s->remember_token, 'right getter';
    ok $s->remember_token('foo@bar.baz'), 'right setter';
    my $cookie = $c->tx->res->cookies->[0];
    is $cookie->name, 'remember_token', 'right set cookie';
    my $token = $c->resultset('AuthenticationRequest')->find_last_by_email('foo@bar.baz')->token;
    is $cookie->value, $token, 'right cookie value';
    is $cookie->path, '/auth/remember-me', 'right cookie path';
    is $c->tx->res->cookies->[1]->name, 'has_remember_token', 'right set cookie';

    # Remove token
    ( $c, $s ) = _init();
    $c->tx->req->cookies( { name => $cookie->name, value => $cookie->value } );
    my $res = $s->remove_remember_token;
    ok !$res, 'right remove remember_me';
    $cookie = $c->tx->res->cookies->[0];
    is $cookie->name, 'remember_token', 'right cookie name';
    is $cookie->expires, 0, 'right cookie remove';
    is $c->tx->res->cookies->[1]->name, 'has_remember_token', 'right cookie remove';
};

subtest 'verify' => sub {
    my ( $c, $s ) = _init();

    my $res;
    my $email = 'foo@bar.baz';
    my $settings = { action => 'foo' };

    # Hack expired
    my $token1 = $s->create_token( $email, $settings );
    my $expires = time - 3600;
    $c->resultset('AuthenticationRequest')->find( { token => $token1->value } )->update( { expires => $expires } );
    $res = $s->verify($token1);
    ok !$res->is_verified, 'right expired';
    is $c->logging->history->[-1]->[1], 'warn', 'right logging';

    my $token2 = $s->create_token( $email, $settings );
    my $token3 = $s->create_token( $email, $settings );
    $res = $s->verify( $token2->value );
    ok !$res->is_verified, 'right not last request';

    $res = $s->verify( $token3->value );
    ok $res->is_verified, 'right first verify';
    is $res->email->value, $email, 'right request email';

    $res = $s->verify( $token3->value );
    ok !$res->is_verified, 'right second verify';
};

done_testing();
