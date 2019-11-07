use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

my $pkg = 'Yetie::Domain::List::SalesOrders';
use_ok $pkg;

sub construct {
    Yetie::Factory->new('list-sales_orders')->construct(@_);
}

subtest 'basic' => sub {
    my $v = construct();
    isa_ok $v, 'Yetie::Domain::List';
};

subtest 'create_sales_order' => sub {
    my $v = construct();
    my $sales_order = $v->create_sales_order( shipping_address => { country_code => 'jp' } );
    is $v->size, 1, 'right create sales_order';
    isa_ok $sales_order, 'Yetie::Domain::Entity::SalesOrder';
    isa_ok $v->first, 'Yetie::Domain::Entity::SalesOrder';
    is $v->first->shipping_address->country_code, 'jp', 'right construct with arguments';

    my $sales_order2 = $v->create_sales_order;
    is $v->size, 2, 'right recreate sales_order';
    isnt $sales_order, $sales_order2, 'right compare object';
};

subtest 'has_shipment' => sub {
    my $v    = construct();
    my $bool = $v->has_shipment;
    is $bool, 0, 'right has not shipment';

    $v = construct( list => [ {} ] );
    $bool = $v->has_shipment;
    is $bool, 1, 'right has shipment';
};

subtest 'is_multiple' => sub {
    my $v    = construct();
    my $bool = $v->is_multiple;
    is $bool, 0, 'right not set shipments';

    $v = construct( list => [ {} ] );
    $bool = $v->is_multiple;
    is $bool, 0, 'right single shipment';

    $v = construct( list => [ {}, {} ] );
    $bool = $v->is_multiple;
    is $bool, 1, 'right multiple shipments';
};

subtest 'count_total_items' => sub {
    my $v = construct( list => [ { items => [ {}, {} ] }, { items => [ {}, {} ] } ] );
    is $v->count_total_items, 4, 'right total items';
};

subtest 'total_quantity' => sub {
    my $v = construct( list => [ { items => [ { quantity => 1 }, { quantity => 2 } ] } ] );
    is $v->total_quantity, 3, 'right total quantity';
};

subtest 'total_shipping_fee' => sub {
    my $v = construct( list => [] );
    is $v->total_shipping_fee_excl_tax, '$0.00', 'right total shipping fee excluding tax(no shipments)';
    is $v->total_shipping_fee_incl_tax, '$0.00', 'right total shipping fee including tax(no shipments)';

    $v = construct(
        list => [
            {
                shipping_fee => 10,
                tax_rule     => {
                    tax_rate => 5,
                },
            },
            {
                shipping_fee => 20,
                tax_rule     => {
                    tax_rate => 5,
                },
            },
        ]
    );
    is $v->total_shipping_fee_excl_tax, '$30.00', 'right total shipping fee excluding tax';
    is $v->total_shipping_fee_incl_tax, '$31.50', 'right total shipping fee including tax';
};

subtest 'revert' => sub {
    my $v = construct();
    is $v->revert, undef, 'right not has shipment';

    $v = construct( list => [ { shipping_address => { postal_code => 12345 }, items => [ { quantity => 1 } ] } ] );
    $v->revert;
    my $data = $v->to_data;
    is $data->[0]->{shipping_address}->{postal_code}, 12345, 'right shipping_address in first element';
    cmp_deeply $data,
      [
        {
            items            => [],
            shipping_address => ignore(),
            shipping_fee     => ignore(),
            tax_rule         => ignore(),
        }
      ],
      'right revert';
};

subtest 'subtotal' => sub {
    my $data = [
        {
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
        },
        {
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
        }
    ];

    my $v = construct( list => [] );
    is $v->subtotal_excl_tax, '$0.00', 'right subtotal excluding tax(no shipments)';
    is $v->subtotal_incl_tax, '$0.00', 'right subtotal including tax(no shipments)';

    $v = construct( list => [ {} ] );
    is $v->subtotal_excl_tax, '$0.00', 'right subtotal excluding tax(no shipment items)';
    is $v->subtotal_incl_tax, '$0.00', 'right subtotal including tax(no shipment items)';

    $v = construct( list => $data );
    is $v->subtotal_excl_tax, '$28.00', 'right subtotal excluding tax';

    $v = construct( list => $data );
    is $v->subtotal_incl_tax, '$29.40', 'right subtotal including tax';
};

done_testing();
