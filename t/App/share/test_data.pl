(
    # Preferences test
    # preferences
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
    'Staff' => {
        id => 2,
        login_id => 'staff',
        # password: 12345678
        password => { hash => 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4=' },
    },
    'Customer' => {
        id => 3,
        emails => [ { email => { address => 'name@domain.com' } } ],
        # password: 12345678
        password => { hash => 'SCRYPT:16384:8:1:+u8IxV+imJ1wVnZqwMQn8lO5NWozQZJesUTI8P+LGNQ=:FxG/e03NIEGMaEoF5qWNCPeR1ULu+UTfhYrJ2cbIPp4=' },
    },
    # Product
    'Product' => [
        [qw/id title description price/],
        [ 1, 'test product1', 'product description1', 100 ],
        [ 2, 'test product2', 'product description2', 200 ],
        [ 3, 'test product3', 'product description3', 300 ],
    ],
)

# INSERT  INTO `markets`.`addons` (`id`, `name`, `is_enabled`)
# VALUES  (1, 'test_addon','1'),
#         (2, 'disable_addon', '0');

# -- Addon triggers
# -- -----------------------------------------------------
# 
# -- INSERT  INTO `markets`.`addon_triggers` (`id`, `addon_id`, `trigger_name`, `priority`)
# -- VALUES  (NULL, '1', 'before_compile_template', '300'),
# --         (NULL, '1', 'before_xxx_action', '500');
