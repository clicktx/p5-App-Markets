use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Entity::Customer';
use_ok $pkg;

subtest 'basic' => sub {
    my $customer = $pkg->new( { id => 1 } );
    isa_ok $customer, 'Yetie::Domain::Entity';

    is $customer->id,           1;
    isa_ok $customer->password, 'Yetie::Domain::Entity::Password';
    isa_ok $customer->emails,   'Yetie::Domain::Collection';
};

done_testing();
