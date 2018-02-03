use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection;
use Yetie::Domain::Entity::Cart::Item;

use_ok 'Yetie::Domain::Entity::Shipment';

subtest 'basic' => sub {
    my $shipment = Yetie::Domain::Entity::Shipment->new( { id => 1 } );
    isa_ok $shipment, 'Yetie::Domain::Entity';

    ok $shipment->id;

    isa_ok $shipment, 'Yetie::Domain::Entity::Shipment';
    can_ok $shipment, 'items';
    can_ok $shipment, 'shipping_address';
    can_ok $shipment, 'item_count';

    isa_ok $shipment->shipping_address, 'Yetie::Domain::Entity::Address';
    isa_ok $shipment->items,            'Yetie::Domain::Collection';

    is $shipment->hash_code, '356a192b7913b04c54574d18c28d46e6395428ab', 'right hash_code';
    is $shipment->id, 1, 'right id';
};

subtest 'equal' => sub {
    my $shipment  = Yetie::Domain::Entity::Shipment->new( { id => 1 } );
    my $shipment2 = Yetie::Domain::Entity::Shipment->new( { id => 2 } );

    is $shipment->equal($shipment),  1, 'right equal item';
    is $shipment->equal($shipment2), 0, 'right not equal item';
};

# subtest 'clone' => sub {};

subtest 'item_count' => sub {
    my $shipment = Yetie::Domain::Entity::Shipment->new( { id => 1 } );
    is $shipment->item_count, 0, 'right item_count';
    $shipment->{items} = Yetie::Domain::Collection->new( 1, 2, 3 );
    is $shipment->item_count, 3, 'right item_count';
};

# subtest 'subtotal_quantity' => sub {};

subtest 'subtotal' => sub {
    my $shipment = Yetie::Domain::Entity::Shipment->new( { id => 1 } );
    $shipment->{items} = Yetie::Domain::Collection->new(
        Yetie::Domain::Entity::Cart::Item->new( quantity => 1, price => 100 ),
        Yetie::Domain::Entity::Cart::Item->new( quantity => 2, price => 100 ),
        Yetie::Domain::Entity::Cart::Item->new( quantity => 3, price => 100 ),
    );
    is $shipment->subtotal, 600, 'right subtotal';
};

done_testing();
