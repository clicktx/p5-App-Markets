(
    # sequence
    'Order::Sequence' => { id => 1 },

    # preferences
    'Preference' => [
        [ 'name', 'value', 'default_value', 'title', 'summary', 'position', 'group_id' ],

        # application
        [ 'admin_uri_prefix', undef, '/admin', 'pref.title.admin_uri_prefix', 'pref.summary.admin_uri_prefix', 100, 1 ],
        [ 'addons_dir', undef, 'addons', 'pref.title.addons_dir', 'pref.summary.addons_dir', 200, 1 ],
        [ 'can_multiple_shipments', undef, 0, 'pref.title.can_multiple_shipments', 'pref.summary.can_multiple_shipments', 200, 1 ],
        [ 'default_language', undef, 'en', 'pref.title.defalut_language', 'pref.summary.defalut_language', 200, 1 ],

        # shop master
        [ 'locale_country', undef, 'US', 'pref.title.locale_country', 'pref.summary.locale_country', 100, 2 ],
        [ 'shop_name', undef, 'Yetie Shop', 'pref.title.shop_name', 'pref.summary.shop_name', 100, 2 ],

        # staff
        [ 'staff_password_min', undef, '4', 'pref.title.staff_password_min', 'pref.summary.staff_password_min', 100, 2 ],
        [ 'staff_password_max', undef, '8', 'pref.title.staff_password_max', 'pref.summary.staff_password_max', 101, 2 ],

        # customer
        [ 'customer_password_min', undef, '4', 'pref.title.customer_password_min', 'pref.summary.customer_password_min', 100, 2 ],
        [ 'customer_password_max', undef, '8', 'pref.title.customer_password_max', 'pref.summary.customer_password_max', 101, 2 ],
    ],

    # reference table
    'Address::Type' => [
        [ qw/id name label/ ],
        [ 1, 'postal', 'Postal Address' ],
        [ 2, 'billing', 'Billing Address' ],
        [ 3, 'shipping', 'Shipping Address' ],
        [ 4, 'delivery', 'Delivery Address' ],
        [ 5, 'residential', 'Residential Address' ],
    ],
)
