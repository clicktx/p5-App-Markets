(
    # sequence
    'Order::Sequence' => { id => 1 },

    # preferences
    'Preference' => [
        [ 'name', 'value', 'default_value', 'title', 'summary', 'position', 'group_id' ],
        [ 'admin_uri_prefix', undef, '/admin', 'pref.title.admin_uri_prefix', 'pref.summary.admin_uri_prefix', 100, 1 ],
        [ 'addons_dir',       undef, 'addons', 'pref.title.addons_dir', 'pref.summary.addons_dir',       200, 1 ],
        [ 'shop_name', undef, 'Markets Shop', '', '', 100, 2 ],

        # customer
        [ 'customer_password_min', undef, '4', '', '', 100, 2 ],
        [ 'customer_password_max', undef, '8', '', '', 101, 2 ],
    ],

    # reference table
    'Reference::AddressType' => [
        [ qw/type/ ],
        [ 'post' ],
        [ 'bill' ],
        [ 'ship' ],
    ],
)
