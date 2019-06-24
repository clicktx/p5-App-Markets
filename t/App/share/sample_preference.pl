(
    # Preferences
    'Preference' => [
        [ 'name', 'value', 'default_value', 'title', 'summary', 'position', 'group_id' ],
        [ 'pref_test1', undef, 'test1', '', '', 100, 1 ],
        [ 'pref_test2', undef, 'test2', '', '', 200, 1 ],
        [ 'pref_test3', undef, 'test3', '', '', 300, 1 ],
        [ 'pref_test4', undef, 'test4', '', '', 400, 1 ],
    ],

    # Addons
    'Addon' => [
        [qw/id name is_enabled/],
        [qw/1 test_addon 1/],
        [qw/2 disable_addon 0/],
    ],
    # 'AddonTrigger' => [
    #     [qw/id addon_id trigger_name priority/],
    #     [qw/100 2 replace_template 333/],
    #     [qw/101 2 filter_form 555/],
    # ],
)
