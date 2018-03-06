use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

my $pkg = 'Yetie::Domain::Entity::Customer';
use_ok $pkg;

subtest 'basic' => sub {
    my $customer = $pkg->new( { id => 1 } );
    isa_ok $customer, 'Yetie::Domain::Entity';

    is $customer->id,           1;
    isa_ok $customer->password, 'Yetie::Domain::Entity::Password';
    isa_ok $customer->emails,   'Yetie::Domain::Collection';
};

subtest 'is_registerd' => sub {
    my $customer = $pkg->new();
    is $customer->is_registerd, 0, 'right not register';

    $customer = Yetie::Domain::Factory->new('entity-customer')->create( password => { hash => 'hoo' } );
    is $customer->is_registerd, 1, 'right register';
};

subtest 'verify_password' => sub {
    my $customer = Yetie::Domain::Factory->new('entity-customer')->create( password => { hash => 'aaa' } );
    is $customer->verify_password('123'), 0, 'right unverified';

    $customer = Yetie::Domain::Factory->new('entity-customer')->create(
        password => {
            hash =>
'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4='
        }
    );
    ok !$customer->verify_password('123'), 'right unverified';
    ok $customer->verify_password('12345678'), 'right verified';
};

done_testing();
