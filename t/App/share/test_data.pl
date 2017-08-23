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
        [qw/id title description price/],
        [ 1, 'test product1', 'product description1', 100 ],
        [ 2, 'test product2', 'product description2', 200 ],
        [ 3, 'test product3', 'product description3', 300 ],
    ],

    # Product Category
    'Product::Category' => [
        [qw/product_id category_id is_primary/],
        [ 1, 3, 1 ],
        [ 1, 5, 0 ],
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
