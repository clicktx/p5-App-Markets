(
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
        [ 4, 4, 1 ],
        [ 5, 4, 1 ],
    ],

    # For Accounts
    'Email' => [
        [qw/id address is_verified/],
        [ 1, 'a@example.org', 1 ],
        [ 2, 'b@example.org', 1 ],
        [ 3, 'c@example.org', 1 ],
        [ 4, 'd@example.org', 0 ],
        [ 5, 'e@example.org', 0 ],
        [ 6, 'f@example.org', 0 ],
        [ 7, 'g@example.org', 0 ],
        [ 8, 'h@example.org', 0 ],
        [ 9, 'i@example.org', 0 ],
    ],
    'Address' => [
        [qw/id country_code line1 line2 level2 level1 postal_code personal_name company_name phone hash/],
        [ 1, 'us', '42 Pendergast St.', '', 'Piedmont', 'SC', '29673', 'Elizabeth T. Peoples', 'Eli Moore Inc', '305-939-8498', '2cd6fbf9747c1f9d791942885eaebf2d4cd0d868' ],
        [ 2, 'us', '7004 Tunnel St.', '', 'New Brunswick', 'NJ', '08901', 'Craig M. Hise', 'Big Apple', '803-767-1849', 'b253e84237954f37eafd4cd0bbfdaffa37e16859' ],
        [ 3, 'us', '803 Wild Rose St.', '', 'Woodstock', 'GA', '30188', 'Mary R. Johnson', '', '804-744-1468', '72131e5f13601203c39023f020a3821c0b6ccc97' ],
        [ 4, 'us', '906 Pearl Ave.', '', 'Patchogue', 'NY', '11772', 'Albert B. Hastings', 'Twin Food Stores', '708-987-1400', '49ba623a69d54b84773a710d743cd26c2b3d38ac' ],
        [ 5, 'jp', '北多久町 4-2-4', 'リバーサイド室瀬212', '多久市', '佐賀県', '8460001', '沢井 咲', '株式会社 フィーデザイン', '0954172962', '9e17dd6f9de2d5c1ecad75f70f8615f4c98050f0' ],
    ],

    # Password
    'Password' => [
        [qw/id hash created_at updated_at/],
        # Staff
        # 12345678
        [ 1, 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4=', '2017-05-01 20:50:25', '2017-05-01 20:50:25' ],
        [ 2, 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4=', '2017-05-02 22:31:17', '2017-05-02 22:31:17' ],
        # Customer
        # 12345678
        [ 3, 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4=', '2017-06-06 19:50:05', '2017-06-06 19:50:05' ],
        # 22334455
        [ 4, 'SCRYPT:16384:8:1:VGcabum1/mW1UQ207AZL4Abdj96TtHYtFWJRjBIuYv8=:5lLK4OF1oG9mdI9G89hgh4kvcXJ8jVnCqIAy8QXwluE=', '2017-07-07 07:02:15', '2017-07-07 07:02:15' ],
        # 44556677
        [ 5, 'SCRYPT:16384:8:1:waCmMNvB2R8Al+WUeJmVxRqn32RfcyZaG0QHoqB+Sjs=:N11GEz66NK2xOmsE6imxtQmHxaKV8c32hgL1mTvWJnY=', '2017-07-08 08:01:02', '2017-07-08 08:01:02' ],
    ],

    # Staffs
    'Staff' => [
        [qw/id login_id created_at updated_at/],
        [ 222, 'default', '2017-05-01 20:50:25', '2017-05-01 20:50:25' ],
        [ 223, 'staff',   '2017-05-02 22:31:17', '2017-05-02 22:31:17' ],
    ],
    'Staff::Password' => [
        [qw/staff_id password_id/],
        [ 222, 1 ],
        [ 223, 2 ],
    ],

    # Customers
    'Customer' => [
        [qw/id created_at updated_at/],
        [ 111, '2017-06-06 19:50:05', '2017-06-16 18:30:12' ],
        [ 112, '2017-07-07 07:02:15', '2017-07-07 07:02:15' ],
        [ 113, '2017-07-08 08:01:02', '2017-07-08 08:01:02' ],
        [ 114, '2017-07-10 10:11:02', '2017-07-10 10:11:02' ],
        [ 115, '2017-07-10 10:20:21', '2017-07-10 10:20:21' ],
    ],
    'Customer::Password' => [
        [qw/customer_id password_id/],
        [ 111, 3 ],
        [ 112, 4 ],
        [ 113, 5 ],
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
        [qw/customer_id address_id address_type_id/],
        [qw/111 1 1/],
        [qw/111 1 2/],
        [qw/111 1 3/],
        [qw/112 2 3/],
        [qw/113 3 3/],
        [qw/113 4 3/],
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
        [ 12, 7, 5 ],
    ],
    'Sales::Order::Item' => [
        [qw/order_id product_id quantity price product_title/],
        [ 1, 3, 3, 300, 'product 3' ],
        [ 1, 1, 1, 101, 'product 1' ], # change price
        [ 2, 2, 2, 200, 'product 2' ],
        [ 3, 4, 4, 333, 'product 4' ],
    ],
)
