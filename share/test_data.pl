(
    # Addons
    'Addon' => [
        [qw/id name is_enabled/],
        [qw/1 default_filter 1/],
        [qw/102 my_addon 1/],
        [qw/103 disable_addon 0/],
        [qw/104 newpage 1/],
    ],
    'Addon::Trigger' => [
        [qw/id addon_id trigger_name priority/],
        [qw/100 102 before_compile_template 300/],
        [qw/101 102 before_xxx_action 500/],
    ],

    # 'Sales::OrderHeader' => {
    #     customer => {
    #         emails => [
    #             { email => { address => 'a@e.com' } }
    #         ],
    #     },
    #     billing_address => {},
    #     # payment => { billing_address => {} },?
    #     shipments => [
    #         { shipping_address => {} }
    #     ],
    # },
    'Email' => [
        [qw/id address is_verified/],
        [ 1, 'a@x.org', 1 ],
        [ 2, 'b@x.org', 1 ],
        [ 3, 'c@x.org', 1 ],
        [ 4, 'd@x.org', 0 ],
        [ 5, 'e@x.org', 0 ],
        [ 6, 'f@x.org', 0 ],
        [ 7, 'g@x.org', 0 ],
        [ 8, 'h@x.org', 0 ],
        [ 9, 'i@x.org', 0 ],
    ],
    'Address' => [
        [qw/id line1/],
        [ 1, 'Silicon Valley' ],
        [ 2, 'San Jose' ],
        [ 3, 'Las Vegas' ],
        [ 4, 'San Francisco ']
    ],
    'Password' => [
        [qw/id hash/],
        [ 1, 'SCRYPT:16384:8:1:lDuUwcU0iGJJt42hmZw/QSF1Zjuoucot8KL/YGyZCmY=:9gLPkZQbRqeFIJxmccG8m9AT/v/6ro0hRYlFLt0Td0M='],
        [ 2, 'bbb'],
        [ 3, 'ccc'],
    ],
    'Customer' => [
        [qw/id created_at password_id/],
        [ 111, '2017-06-06 19:50:05', 1 ],
        [ 112, '2017-07-07 07:02:15' ],
        [ 113, '2017-07-07 07:02:15' ],
        [ 114, '2017-07-07 07:02:15' ],
        [ 115, '2017-07-07 07:02:15' ],
        [ 116, '2017-07-07 07:02:15' ],
        [ 117, '2017-07-07 07:02:15' ],
        [ 118, '2017-07-07 07:02:15' ],
        [ 119, '2017-07-07 07:02:15' ],
        [ 120, '2017-07-07 07:02:15' ],
        [ 121, '2017-07-07 07:02:15' ],
        [ 122, '2017-07-07 07:02:15' ],
    ],
    'Customer::Email' => [
        [qw/customer_id email_id is_primary/],
        [ 111, 3, 1 ],
        [ 111, 1, 0 ],
        [ 112, 2, 0 ],
        [ 112, 4, 0 ],
        [ 112, 5, 0 ],
        [ 112, 6, 0 ],
        [ 112, 7, 0 ],
        [ 112, 8, 0 ],
    ],
    'Customer::Address' => [
        [qw/type customer_id address_id/],
        [qw/post 111 1/],
        [qw/bill 111 1/],
        [qw/ship 111 1/],
        [qw/ship 111 2/],
    ],
    'Sales::OrderHeader' => [
        [qw/id created_at customer_id address_id/],
        [ 1, '2017-06-06 20:01:35', 111, 1 ],
        [ 2, '2017-07-07 07:02:15', 112, 2 ],
    ],
    'Sales::Order::Shipment' => [
        [qw/order_header_id id address_id/],
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
