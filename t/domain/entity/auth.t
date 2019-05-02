use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Auth';
use_ok $pkg;

subtest 'basic' => sub {
    my $auth = Yetie::Factory->new('entity-auth')->construct();
    ok $auth;
    isa_ok $auth->email,   'Yetie::Domain::Value::Email';
    isa_ok $auth->expires, 'Yetie::Domain::Value::Expires';
    isa_ok $auth->token,   'Yetie::Domain::Value::Token';

    can_ok $auth, 'continue_url';
    can_ok $auth, 'error_message';
    can_ok $auth, 'is_activated';
    can_ok $auth, 'is_verified';
    can_ok $auth, 'remote_address';
};

subtest 'continue' => sub {
    my $f = Yetie::Factory->new('entity-auth');

    my $auth = $f->construct();
    is $auth->continue, 'rn.home', 'right default';

    $auth = $f->construct( continue_url => 'foo' );
    is $auth->continue, 'foo', 'right continue_url';
};

subtest 'verify_token' => sub {
    my $f = Yetie::Factory->new('entity-auth');

    my $auth = $f->construct(
        token   => 'abc',
        expires => time,
    );
    $auth->verify_token('abc');
    ok $auth->is_verified, 'right verified';

    $auth->verify_token('aaa');
    ok !$auth->is_verified, 'right fail';
    like $auth->error_message, qr/Different from last token/, 'right error message';

    $auth = $f->construct(
        token        => 'abc',
        expires      => time,
        is_activated => 1,
    );
    $auth->verify_token('abc');
    ok !$auth->is_verified, 'right fail';
    like $auth->error_message, qr/Activated/, 'right error message';

    $auth = $f->construct(
        token        => 'abc',
        expires      => time - 3600,
        is_activated => 0,
    );
    $auth->verify_token('abc');
    ok !$auth->is_verified, 'right fail';
    like $auth->error_message, qr/Expired/, 'right error message';
};

done_testing();
