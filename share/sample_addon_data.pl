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
)
