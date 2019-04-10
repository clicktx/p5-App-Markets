use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Auth';
use_ok $pkg;

subtest 'basic' => sub {
    my $auth = Yetie::Factory->new('entity-auth')->construct();
    ok $auth;
    isa_ok $auth->token,   'Yetie::Domain::Value::Token';
    isa_ok $auth->email,   'Yetie::Domain::Value::Email';
    isa_ok $auth->expires, 'Yetie::Domain::Value::Expires';

    can_ok $auth, 'remote_address';
    can_ok $auth, 'is_activated';
    can_ok $auth, 'is_valid';
    can_ok $auth, 'error_message';
};

subtest 'validate_token' => sub {
    my $f = Yetie::Factory->new('entity-auth');

    my $auth = $f->construct(
        token   => 'abc',
        expires => time,
    );
    $auth->validate_token('abc');
    ok $auth->is_valid, 'right validate';

    $auth->validate_token('aaa');
    ok !$auth->is_valid, 'right fail';
    like $auth->error_message, qr/Different from last token/, 'right error message';

    $auth = $f->construct(
        token        => 'abc',
        expires      => time,
        is_activated => 1,
    );
    $auth->validate_token('abc');
    ok !$auth->is_valid, 'right fail';
    like $auth->error_message, qr/Activated/, 'right error message';

    $auth = $f->construct(
        token        => 'abc',
        expires      => time - 3600,
        is_activated => 0,
    );
    $auth->validate_token('abc');
    ok !$auth->is_valid, 'right fail';
    like $auth->error_message, qr/Expired/, 'right error message';
};

done_testing();
