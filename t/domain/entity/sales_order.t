use Mojo::Base -strict;
use Test::More;
use Markets::Domain::Factory;

my $test_data = {};

sub _create_entity {
    Markets::Domain::Factory->factory('entity-sales_order')->create($test_data);
}

use_ok 'Markets::Domain::Entity::SalesOrder';

subtest 'basic' => sub {
    my $e = Markets::Domain::Entity::SalesOrder->new();
    isa_ok $e, 'Markets::Domain::Entity';

    can_ok $e, 'billing_address';
    can_ok $e, 'created_at';
    can_ok $e, 'customer';
    can_ok $e, 'shipments';
    can_ok $e, 'updated_at';
};

done_testing();
