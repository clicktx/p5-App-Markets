use Mojo::Base -strict;
use Test::More;
use Markets::Domain::Collection;
use Markets::Domain::Entity::SellingItem;

use_ok 'Markets::Domain::Entity::Cart::Shipment';

subtest 'basic' => sub {
    my $shipment = Markets::Domain::Entity::Cart::Shipment->new( { id => 1 } );
    isa_ok $shipment, 'Markets::Domain::Entity';

    ok $shipment->id;
    isa_ok $shipment->shipping_items, 'Markets::Domain::Collection';

    isa_ok $shipment, 'Markets::Domain::Entity::Cart::Shipment';
    can_ok $shipment, 'shipping_items';
    can_ok $shipment, 'shipping_address';
    can_ok $shipment, 'item_count';
    is $shipment->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash_code';
    is $shipment->id, 1, 'right id';
};

subtest 'is_equal' => sub {
    my $shipment  = Markets::Domain::Entity::Cart::Shipment->new( { id => 1 } );
    my $shipment2 = Markets::Domain::Entity::Cart::Shipment->new( { id => 2 } );

    is $shipment->is_equal($shipment),  1, 'right equal item';
    is $shipment->is_equal($shipment2), 0, 'right not equal item';
};

# subtest 'clone' => sub {};

subtest 'item_count' => sub {
    my $shipment = Markets::Domain::Entity::Cart::Shipment->new( { id => 1 } );
    is $shipment->item_count, 0, 'right item_count';
    $shipment->{shipping_items} = Markets::Domain::Collection->new( 1, 2, 3 );
    is $shipment->item_count, 3, 'right item_count';
};

# subtest 'subtotal_quantity' => sub {};

subtest 'subtotal' => sub {
    my $shipment = Markets::Domain::Entity::Cart::Shipment->new( { id => 1 } );
    $shipment->{shipping_items} = Markets::Domain::Collection->new(
        Markets::Domain::Entity::SellingItem->new( quantity => 1, price => 100 ),
        Markets::Domain::Entity::SellingItem->new( quantity => 2, price => 100 ),
        Markets::Domain::Entity::SellingItem->new( quantity => 3, price => 100 ),
    );
    is $shipment->subtotal, 600, 'right subtotal';
};

done_testing();
