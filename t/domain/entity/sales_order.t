use Mojo::Base -strict;
use Test::More;
use Test::Exception;
use Yetie::Domain::Collection;
use Yetie::Domain::Entity::LineItem;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::Entity::SalesOrder';
use_ok $pkg;

sub construct { Yetie::Factory->new('entity-sales_order')->construct(@_) }

subtest 'basic' => sub {
    my $sales_order = construct( id => 1 );
    isa_ok $sales_order, 'Yetie::Domain::Entity';

    ok $sales_order->id;

    isa_ok $sales_order, 'Yetie::Domain::Entity::SalesOrder';
    can_ok $sales_order, 'items';
    can_ok $sales_order, 'shipping_address';
    can_ok $sales_order, 'count_items';

    isa_ok $sales_order->items,            'Yetie::Domain::List::LineItems';
    isa_ok $sales_order->shipping_address, 'Yetie::Domain::Entity::Address';
    isa_ok $sales_order->shipping_fee,     'Yetie::Domain::Value::Price';
    lives_ok { $sales_order->shipping_fee( $sales_order->shipping_fee ) } 'right read-write';
    isa_ok $sales_order->tax_rule, 'Yetie::Domain::Entity::TaxRule';

    is $sales_order->id, 1, 'right id';
};

subtest 'equals' => sub {
    my $sales_order  = construct( id => 1 );
    my $sales_order2 = construct( id => 2 );

    is $sales_order->equals($sales_order),  1, 'right equals item';
    is $sales_order->equals($sales_order2), 0, 'right not equals item';
};

subtest 'count_items' => sub {
    my $sales_order = construct( id => 1 );
    is $sales_order->count_items, 0, 'right count_items';

    $sales_order = construct( id => 1, items => [ {}, {}, {} ] );
    is $sales_order->count_items, 3, 'right count_items';
};

subtest 'subtotal' => sub {
    my $sales_order = construct(
        id    => 1,
        items => [
            {
                price    => 1,
                quantity => 1,
                tax_rule => {
                    tax_rate => 5,
                },
            },
            {
                price    => 2,
                quantity => 2,
                tax_rule => {
                    tax_rate => 5,
                },
            },
            {
                price    => 3,
                quantity => 3,
                tax_rule => {
                    tax_rate => 5,
                },
            }
        ]
    );

    subtest 'excluding tax' => sub {
        is $sales_order->subtotal_excl_tax, '$14.00', 'right subtotal excluding tax';
    };
    subtest 'including tax' => sub {
        is $sales_order->subtotal_incl_tax, '$14.70', 'right subtotal including tax';
    };
};

subtest 'shipping_fee' => sub {
    my $sales_order = construct(
        shipping_fee => 100,
        tax_rule     => {
            tax_rate => 5,
        },
    );

    subtest 'excluding tax' => sub {
        is $sales_order->shipping_fee_excl_tax, '$100.00', 'right shipping fee excluding tax';
    };
    subtest 'including tax' => sub {
        is $sales_order->shipping_fee_incl_tax, '$105.00', 'right shipping fee including tax';
    };

    $sales_order = construct(
        shipping_fee => { value => 105, is_tax_included => 1 },
        tax_rule     => {
            tax_rate => 5,
        },
    );

    subtest 'excluding tax' => sub {
        is $sales_order->shipping_fee_excl_tax, '$100.00', 'right shipping fee excluding tax';
    };
    subtest 'including tax' => sub {
        is $sales_order->shipping_fee_incl_tax, '$105.00', 'right shipping fee including tax';
    };
};

done_testing();
