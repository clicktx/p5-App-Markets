use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

use_ok 'Yetie::Domain::Entity::Staff';
my $pkg = 'Yetie::Domain::Entity::Staff';

subtest 'basic' => sub {
    my $staff = $pkg->new( id => 1 );
    isa_ok $staff, 'Yetie::Domain::Entity';

    is $staff->id, 1, 'right staff ID';
    isa_ok $staff->password, 'Yetie::Domain::Entity::Password';
    is $staff->logged_in, 0, 'right not logged_in';

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
    my $staff = Yetie::Domain::Factory->new('entity-staff')->create( password => { hash => 'aaa' } );
    is $staff->verify_password('123'), 0, 'right unverified';
    ok !$staff->logged_in, 'right not logged in';

    $staff = Yetie::Domain::Factory->new('entity-staff')->create(
        password => {
            hash =>
'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4='
        }
    );
    is $staff->verify_password('123'), 0, 'right unverified';
    ok !$staff->logged_in, 'right not logged in';
    is $staff->verify_password('12345678'), 1, 'right verified';
    ok $staff->logged_in, 'right logged in';
};

done_testing();
