use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Shipment';

subtest 'basic' => sub {
    my $shipment = Markets::Domain::Entity::Shipment->new( { id => 1 } );
    isa_ok $shipment, 'Markets::Domain::Entity';

    ok $shipment->id;
    isa_ok $shipment->shipping_items, 'Markets::Domain::Collection';
};

my $shipment = Markets::Domain::Entity::Shipment->new(
    {
        id => 1,
    }
);

isa_ok $shipment, 'Markets::Domain::Entity::Shipment';
can_ok $shipment, 'shipping_items';
can_ok $shipment, 'shipping_address';
can_ok $shipment, 'item_count';

is $shipment->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash_code';
is $shipment->id, 1, 'right id';

my $shipment2 = Markets::Domain::Entity::Shipment->new(
    {
        id => 2,
    }
);

is $shipment->is_equal($shipment),  1, 'right equal item';
is $shipment->is_equal($shipment2), 0, 'right not equal item';

done_testing();
