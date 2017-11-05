use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Customer';

subtest 'basic' => sub {
    my $customer = Yetie::Domain::Entity::Customer->new( { id => 1 } );
    isa_ok $customer, 'Yetie::Domain::Entity';

    is $customer->id,           1;
    isa_ok $customer->password, 'Yetie::Domain::Entity::Password';
    isa_ok $customer->emails,   'Yetie::Domain::Collection';
};

done_testing();
