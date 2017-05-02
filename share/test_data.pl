(
    # Addons
    'Addon' => [
        [qw/id name is_enabled/],
        [qw/1 default_filter 1/],
        [qw/102 my_addon 1/],
        [qw/103 disable_addon 0/],
        [qw/104 newpage 1/],
    ],
    'Addon::Hook' => [
        [qw/id addon_id hook_name priority/],
        [qw/100 102 before_compile_template 300/],
        [qw/101 102 before_xxx_action 500/],
    ],

    # Order example
    # 'Sales::Order::Billing' => [
    #     {
    #         id => 33,
    #         billing_address => 'Silicon Valley',
    #     },
    #     {
    #         id => 34,
    #         billing_address => 'Las Vegas',
    #     },
    #     {
    #         id => 35,
    #         billing_address => 'Tokyo',
    #     }
    # ],
    # 'Sales::Order' => [
    #     [qw/id order_number billing_id shipping_address created_at items/],
    #     [1,  111,          33,         'San Francisco', '2017-03-03 13:03:21',
    #         [
    #             [qw/product_id quantity/],
    #             [qw/3          3/],
    #             [qw/1          1/],
    #         ]
    #     ],
    #     [2,  111,          33,         'Los Angeles', '2017-03-03 13:03:21',
    #         [
    #             { product_id => 2, quantity => 2 }
    #         ]
    #     ],
    #     [3,  222,          34,         'Las Vegas', '2017-05-05 22:30:15',
    #         [
    #             { product_id => 4, quantity => 4 }
    #         ]
    #     ],
    #     [4,  223,          35,         'Yokohama', '2017-06-06 20:01:35',
    #         [
    #             { product_id => 5, quantity => 5 }
    #         ]
    #     ],
    #     [5,  223,          35,         'Okinawa', '2017-06-06 20:01:35',
    #         [
    #             { product_id => 6, quantity => 6 }
    #         ]
    #     ],
    # ],

    Order => [
        [qw/id created_at billing_address/],
        [1, '2017-06-06 20:01:35', 'Silicon Valley'],
        [2, '2017-07-07 07:02:15', 'Las Vegas'],
    ],
    'Order::Shipment' => [
        [qw/order_id id shipping_address/],
        [1, 1, 'Silicon Valley'],
        [1, 2, 'Los Angeles'],
        [2, 3, 'San Francisco'],
    ],
    'Order::Shipment::Item' => [
        [qw/shipment_id product_id quantity/],
        [1, 3, 3],
        [1, 1, 1],
        [2, 2, 2],
    ],
)
