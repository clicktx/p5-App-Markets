use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Customer';
use_ok $pkg;

subtest 'basic' => sub {
    my $customer = $pkg->new( { id => 1 } );
    isa_ok $customer, 'Yetie::Domain::Entity';

    is $customer->id,           1;
    isa_ok $customer->password, 'Yetie::Domain::Value::Password';
    isa_ok $customer->emails,   'Yetie::Domain::List::Emails';
};

subtest 'has_password' => sub {
    my $customer = $pkg->new();
    is $customer->has_password, 0, 'right not register';

    $customer = Yetie::Factory->new('entity-customer')->construct( password => { value => 'hoo' } );
    is $customer->has_password, 1, 'right register';
};

subtest 'is_registered' => sub {
    my $customer = $pkg->new();
    is $customer->is_registered, 0, 'right not register';

    $customer = Yetie::Factory->new('entity-customer')->construct( id => 1 );
    is $customer->is_registered, 1, 'right register';
};

done_testing();
