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
        [qw/100 102 replace_template 333/],
        [qw/101 102 filter_form 555/],
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
        # 12345678
        [ 1, 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4='],
        # 22334455
        [ 2, 'SCRYPT:16384:8:1:VGcabum1/mW1UQ207AZL4Abdj96TtHYtFWJRjBIuYv8=:5lLK4OF1oG9mdI9G89hgh4kvcXJ8jVnCqIAy8QXwluE='],
        # 44556677
        [ 3, 'SCRYPT:16384:8:1:waCmMNvB2R8Al+WUeJmVxRqn32RfcyZaG0QHoqB+Sjs=:N11GEz66NK2xOmsE6imxtQmHxaKV8c32hgL1mTvWJnY='],
        # 12345678
        [ 4, 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4='],
    ],
    'Staff' => [
        [qw/id login_id password_id created_at updated_at/],
        [ 222, 'default', 1, '2017-05-01 20:50:25', '2017-05-01 20:50:25' ],
    ],
    'Customer' => [
        [qw/id password_id created_at updated_at/],
        [ 111, 1, '2017-06-06 19:50:05', '2017-06-16 18:30:12' ],
        [ 112, 2, '2017-07-07 07:02:15', '2017-07-07 07:02:15' ],
        [ 113, 3, '2017-07-08 08:01:02', '2017-07-08 08:01:02' ],
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

    # Product
    'Product' => [
        [qw/id title description price/],
        [ 1, 'test product1', 'product description1', 100 ],
        [ 2, 'test product2', 'product description2', 200 ],
        [ 3, 'test product3', 'product description3', 300 ],
    ],
)
