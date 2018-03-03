use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Entity::Customer';
use_ok $pkg;

subtest 'basic' => sub {
    my $customer = $pkg->new( { id => 1 } );
    isa_ok $customer, 'Yetie::Domain::Entity';

    is $customer->id,           1;
    is $customer->logged_in,    0;
    isa_ok $customer->password, 'Yetie::Domain::Entity::Password';
    isa_ok $customer->emails,   'Yetie::Domain::Collection';
};

subtest 'is_registerd' => sub {
    my $customer = $pkg->new();
    is $customer->is_registerd, 0, 'right not register';

    $customer = Yetie::Domain::Factory->new('entity-customer')->create( password => { hash => 'hoo' } );
    is $customer->is_registerd, 1, 'right register';
};

done_testing();
