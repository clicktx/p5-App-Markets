use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Customer';

subtest 'basic' => sub {
    my $customer = Markets::Domain::Entity::Customer->new( { id => 1 } );
    isa_ok $customer, 'Markets::Domain::Entity';

    is $customer->id,           1;
    isa_ok $customer->password, 'Markets::Domain::Entity::Password';
    isa_ok $customer->emails,   'Markets::Domain::Collection';
};

done_testing();
