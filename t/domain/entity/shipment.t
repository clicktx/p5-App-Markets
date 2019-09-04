use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection;
use Yetie::Domain::Entity::LineItem;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::Shipment';
use_ok $pkg;

sub construct { Yetie::Factory->new('entity-shipment')->construct(@_) }

subtest 'basic' => sub {
    my $shipment = construct( id => 1 );
    isa_ok $shipment, 'Yetie::Domain::Entity';

    ok $shipment->id;

    isa_ok $shipment, 'Yetie::Domain::Entity::Shipment';
    can_ok $shipment, 'items';
    can_ok $shipment, 'shipping_address';
    can_ok $shipment, 'count_items';

    isa_ok $shipment->shipping_address, 'Yetie::Domain::Entity::Address';
    isa_ok $shipment->items,            'Yetie::Domain::List::LineItems';

    is $shipment->id, 1, 'right id';
};

subtest 'equals' => sub {
    my $shipment  = construct( id => 1 );
    my $shipment2 = construct( id => 2 );

    is $shipment->equals($shipment),  1, 'right equals item';
    is $shipment->equals($shipment2), 0, 'right not equals item';
};

subtest 'count_items' => sub {
    my $shipment = construct( id => 1 );
    is $shipment->count_items, 0, 'right count_items';

    $shipment = construct( id => 1, items => [ {}, {}, {} ] );
    is $shipment->count_items, 3, 'right count_items';
};

subtest 'subtotal' => sub {
    my $shipment = construct( id => 1 );
    $shipment->{items} = Yetie::Domain::Collection->new(
        Yetie::Factory->new('entity-line_item')->construct( quantity => 1, price => 100 ),
        Yetie::Factory->new('entity-line_item')->construct( quantity => 2, price => 100 ),
        Yetie::Factory->new('entity-line_item')->construct( quantity => 3, price => 100 ),
    );
    is $shipment->subtotal, 600, 'right subtotal';
};

done_testing();
