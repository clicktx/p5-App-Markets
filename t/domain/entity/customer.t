use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

my $pkg = 'Yetie::Domain::Entity::Customer';
use_ok $pkg;

subtest 'basic' => sub {
    my $customer = $pkg->new( { id => 1 } );
    isa_ok $customer, 'Yetie::Domain::Entity';

    is $customer->id,           1;
    isa_ok $customer->password, 'Yetie::Domain::Value::Password';
    isa_ok $customer->emails,   'Yetie::Domain::Collection';
};

subtest 'is_registered' => sub {
    my $customer = $pkg->new();
    is $customer->is_registered, 0, 'right not register';

    $customer = Yetie::Domain::Factory->new('entity-customer')->create( password => { value => 'hoo' } );
    is $customer->is_registered, 1, 'right register';
};

done_testing();
