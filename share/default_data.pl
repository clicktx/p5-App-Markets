(
    # sequence
    'Order::Sequence' => { id => 1 },

    # preferences
    'Preference' => [
        [ 'name', 'value', 'default_value', 'title', 'summary', 'position', 'group_id' ],

        # application
        [ 'admin_uri_prefix', undef, '/admin', 'pref.title.admin_uri_prefix', 'pref.summary.admin_uri_prefix', 100, 1 ],
        [ 'addons_dir',       undef, 'addons', 'pref.title.addons_dir', 'pref.summary.addons_dir',       200, 1 ],

        # shop master
        [ 'locale_country', undef, 'US', 'pref.title.locale_country', 'pref.summary.locale_country', 100, 2 ],
        [ 'shop_name', undef, 'Markets Shop', 'pref.title.shop_name', 'pref.summary.shop_name', 100, 2 ],

        # customer
        [ 'customer_password_min', undef, '4', 'pref.title.customer_password_min', 'pref.summary.customer_password_min', 100, 2 ],
        [ 'customer_password_max', undef, '8', 'pref.title.customer_password_max', 'pref.summary.customer_password_max', 101, 2 ],
    ],

    # reference table
    'Reference::AddressType' => [
        [ qw/type/ ],
        [ 'post' ],
        [ 'bill' ],
        [ 'ship' ],
    ],
)
