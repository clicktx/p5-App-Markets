(
    # sequence
    'Order::Sequence' => { id => 1 },

    # preferences
    'Preference' => [
        [ 'key_name', 'value', 'default_value', 'summary', 'position', 'group_id' ],
        [ 'admin_uri_prefix', undef, '/admin', 'pref.summary.admin_uri_prefix', undef, undef ],
        [ 'addons_dir',       undef, 'addons', 'pref.summary.addons_dir',       undef, undef ],
    ],

    # reference table
    'Reference::AddressType' => [
        [ qw/address_type/ ],
        [ 'post' ],
        [ 'bill' ],
        [ 'ship' ],
    ],
)
