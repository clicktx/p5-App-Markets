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

    # Category
    'Category' => [
        [qw/id root_id lft rgt level title/],
        [ 1, 1, 1, 6, 0, 'Sports'],
        [ 2, 2, 1, 22, 0, 'Fashion'],
        [ 3, 1, 2, 3, 1, 'Golf'],
        [ 4, 1, 4, 5, 1, 'Soccer'],
        [ 5, 2, 2, 13, 1, 'Women'],
        [ 6, 2, 14, 15, 1, 'Men'],
        [ 7, 2, 16, 17, 1, 'Girls'],
        [ 8, 2, 18, 19, 1, 'Boys'],
        [ 9, 2, 20, 21, 1, 'Baby'],
        [ 10, 2, 3, 12, 2, 'Clothing'],
        [ 11, 2, 4, 9, 3, 'Dresses'],
        [ 12, 2, 10, 11, 3, 'Tops & Tees'],
        [ 13, 2, 5, 6, 4, 'Casual'],
        [ 14, 2, 7, 8, 4, 'Formal'],
    ],

    # Product
    'Product' => [
        [qw/id title description price created_at updated_at/],
        [ 1, 'test product1', 'product description1', 100, '2017-08-23 23:47:04', '2017-08-23 23:47:04' ],
        [ 2, 'test product2', 'product description2', 200, '2017-08-23 23:55:12', '2017-08-23 23:55:12' ],
        [ 3, 'test product3', 'product description', 300, '2017-08-23 23:59:35', '2017-08-23 23:59:35' ],
        [ 4, 'test product4', 'product description', 333, '2017-08-24 01:01:11', '2017-08-24 01:01:11' ],
        [ 5, 'test product5', 'product description', 333, '2017-08-24 01:01:35', '2017-08-24 01:01:35' ],
        [ 6, 'test product6', 'product description', 333, '2017-08-24 01:02:02', '2017-08-24 01:02:02' ],
        [ 7, 'test product7', 'product description', 333, '2017-08-24 01:02:21', '2017-08-24 01:02:21' ],
        [ 8, 'test product8', 'product description', 333, '2017-08-24 01:02:34', '2017-08-24 01:02:34' ],
        [ 9, 'test product9', 'product description', 333, '2017-08-24 01:02:45', '2017-08-24 01:02:45' ],
        [ 10, 'test product10', 'product description', 333, '2017-08-24 01:02:56', '2017-08-24 01:02:56' ],
    ],

    # Product Category
    'Product::Category' => [
        [qw/product_id category_id is_primary/],
        [ 1, 3, 1 ],
        [ 1, 5, 0 ],
        [ 2, 3, 1 ],
        [ 3, 3, 1 ],
    ],

    # For Accounts
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
        [ 4, 'San Francisco'],
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

    # Staffs
    'Staff' => [
        [qw/id login_id password_id created_at updated_at/],
        [ 222, 'default', 1, '2017-05-01 20:50:25', '2017-05-01 20:50:25' ],
        [ 223, 'staff', 1, '2017-05-02 22:31:17', '2017-05-02 22:31:17' ],
    ],

    # Customers
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
        [ 112, 2, 1 ],
        [ 112, 4, 0 ],
        [ 112, 5, 0 ],
        [ 112, 6, 0 ],
        [ 112, 7, 0 ],
        [ 112, 8, 0 ],
        [ 113, 9, 1 ],
    ],
    'Customer::Address' => [
        [qw/type customer_id address_id/],
        [qw/post 111 1/],
        [qw/bill 111 1/],
        [qw/ship 111 1/],
        [qw/ship 112 2/],
        [qw/ship 113 3/],
        [qw/ship 113 4/],
    ],

    # Orders
    'Sales' => [
        [qw/id customer_id address_id created_at updated_at/],
        [ 1, 111, 1, '2017-06-06 20:01:35', '2017-06-06 20:01:35' ],
        [ 2, 112, 2, '2017-07-07 07:02:15', '2017-07-07 07:02:15' ],
        [ 3, 113, 4, '2017-07-07 07:08:05', '2017-07-07 07:08:05' ],
        [ 4, 113, 4, '2017-07-07 07:10:03', '2017-07-07 07:10:03' ],
        [ 5, 113, 4, '2017-07-07 07:12:15', '2017-07-07 07:12:15' ],
        [ 6, 113, 4, '2017-07-07 07:14:45', '2017-07-07 07:14:45' ],
        [ 7, 113, 4, '2017-07-07 07:15:01', '2017-07-07 07:15:01' ],
    ],
    'Sales::Order' => [
        [qw/id sales_id address_id/],
        [ 1, 1, 1 ],
        [ 2, 1, 3 ],
        [ 3, 2, 2 ],
        [ 4, 3, 3 ],
        [ 5, 3, 4 ],
        [ 6, 4, 3 ],
        [ 7, 4, 4 ],
        [ 8, 5, 3 ],
        [ 9, 5, 4 ],
        [ 10, 6, 3 ],
        [ 11, 6, 4 ],
        [ 12, 7, 4 ],
    ],
    'Sales::Order::Item' => [
        [qw/order_id product_id quantity price/],
        [ 1, 3, 3, 300 ],
        [ 1, 1, 1, 101 ], # change price
        [ 2, 2, 2, 200 ],
        [ 3, 4, 4, 333 ],
    ],
)
