use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Authorization';
use_ok $pkg;

subtest 'basic' => sub {
    my $auth = Yetie::Factory->new('entity-authorization')->construct();
    ok $auth;
    isa_ok $auth->token,   'Yetie::Domain::Value::Token';
    isa_ok $auth->email,   'Yetie::Domain::Value::Email';
    isa_ok $auth->expires, 'Yetie::Domain::Value::Expires';

    can_ok $auth, 'request_ip';
    can_ok $auth, 'is_activated';
    can_ok $auth, 'created_at';
    can_ok $auth, 'updated_at';
    can_ok $auth, 'error_message';
};

subtest 'is_validated' => sub {
    my $f = Yetie::Factory->new('entity-authorization');

    my $auth = $f->construct(
        token   => 'abc',
        expires => time,
    );
    my $bool = $auth->is_validated('abc');
    is $bool, 1, 'right validate';

    $bool = $auth->is_validated('aaa');
    is $bool, 0, 'right fail';
    like $auth->error_message, qr/Different from last token/, 'right error message';

    $auth = $f->construct(
        token        => 'abc',
        expires      => time,
        is_activated => 1,
    );
    $bool = $auth->is_validated('abc');
    is $bool, 0, 'right fail';
    like $auth->error_message, qr/Activated/, 'right error message';

    $auth = $f->construct(
        token        => 'abc',
        expires      => time - 3600,
        is_activated => 0,
    );
    $bool = $auth->is_validated('abc');
    is $bool, 0, 'right fail';
    like $auth->error_message, qr/Expired/, 'right error message';
};

done_testing();
