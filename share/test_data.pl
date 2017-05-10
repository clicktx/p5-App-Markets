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

    'Customer' => [
        [qw/id/],
        [111],
        [112],
    ],
    'Address' => [
        [qw/id line1/],
        [1, 'Silicon Valley'],
        [2, 'San Jose'],
        [3, 'Las Vegas'],
        [4, 'San Francisco']
    ],
    'Sales::Order' => [
        [qw/id created_at customer_id address_id/],
        [ 1, '2017-06-06 20:01:35', 111, 1 ],
        [ 2, '2017-07-07 07:02:15', 112, 2 ],
    ],
    'Sales::Order::Shipment' => [
        [qw/order_id id address_id/],
        [ 1, 1, 1 ],
        [ 1, 2, 3 ],
        [ 2, 3, 4 ],
    ],
    'Sales::Order::Shipment::Item' => [
        [qw/shipment_id product_id quantity/],
        [ 1, 3, 3 ],
        [ 1, 1, 1 ],
        [ 2, 2, 2 ],
        [ 3, 4, 4 ],
    ],
)
