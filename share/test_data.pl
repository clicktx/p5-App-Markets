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

    'Sales::Order' => [
        [qw/id created_at customer/],
        [ 1, '2017-06-06 20:01:35', { id => 111 } ],
        [ 2, '2017-07-07 07:02:15', { id => 112 } ],
    ],
    'Sales::Order::Shipment' => [
        [qw/order_id id shipping_address/],
        [ 1, 1, { id => 1, line1 => 'Silicon Valley' } ],
        [ 1, 2, { id => 2, line1 => 'Las Vegas' } ],
        [ 2, 3, { id => 2, } ],
    ],
    'Sales::Order::Shipment::Item' => [
        [qw/shipment_id product_id quantity/],
        [ 1, 3, 3 ],
        [ 1, 1, 1 ],
        [ 2, 2, 2 ],
        [ 3, 4, 4 ],
    ],
)
