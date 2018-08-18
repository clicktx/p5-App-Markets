use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

use_ok 'Yetie::Domain::Entity::Staff';
my $pkg = 'Yetie::Domain::Entity::Staff';

subtest 'basic' => sub {
    my $staff = $pkg->new( id => 1 );
    isa_ok $staff, 'Yetie::Domain::Entity';

    is $staff->id, 1, 'right staff ID';
    isa_ok $staff->password, 'Yetie::Domain::Value::Password';

    can_ok $staff, 'login_id';
    can_ok $staff, 'created_at';
    can_ok $staff, 'updated_at';
};

subtest 'is_staff' => sub {
    my $staff = $pkg->new();
    ok !$staff->is_staff;
    $staff = $pkg->new( id => 1 );
    ok $staff->is_staff;
};

subtest 'verify_password' => sub {
    my $staff = Yetie::Domain::Factory->new('entity-staff')->create( password => { value => 'aaa' } );
    is $staff->verify_password('123'), 0, 'right unverified';

    $staff = Yetie::Domain::Factory->new('entity-staff')->create(
        password => {
            value =>
'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4='
        }
    );
    ok !$staff->verify_password('123'), 'right unverified';
    ok $staff->verify_password('12345678'), 'right verified';
};

done_testing();
