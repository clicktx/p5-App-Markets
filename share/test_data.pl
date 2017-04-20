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
    'Order' => {
        'billing_address' => 'Silicon Valley',
        'customer_id'     => undef,
        'order_number'    => '1',
        'shipments'       => [
            {
                'shipping_address' => 'San Francisco',
                'shipping_items'   => [
                    { 'product_id' => '3', 'quantity'   => '3' },
                    { 'product_id' => '1', 'quantity'   => '1' },
                ]
            },
            {
                'shipping_address' => 'Los Angeles',
                'shipping_items'   => [
                    { 'product_id' => '2', 'quantity'   => '2' },
                ]
            },
        ]
    },
)
