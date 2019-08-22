(
    # preferences
    'Preference' => [
        [ 'name', 'default_value', 'title', 'summary', 'position', 'group_id' ],

        # location
        [ 'locale_language_code', 'en', 'pref.title.locale_language_code', 'pref.summary.locale_language_code', 10, 1 ],
        [ 'locale_country_code', 'US', 'pref.title.locale_country_code', 'pref.summary.locale_country_code', 20, 1 ],
        [ 'locale_currency_code', 'USD', 'pref.title.locale_currency_code', 'pref.summary.locale_currency_code', 30, 1 ],

        # Price including tax
        [ 'is_price_including_tax', '0', 'pref.title.is_price_including_tax', 'pref.summary.is_price_including_tax', 40, 1 ],
        # Decimal rounding mode 'even' or 'trunc'
        [ 'default_round_mode', 'even', 'pref.title.default_round_mode', 'pref.summary.default_round_mode', 50, 1 ],

        # shop master
        [ 'shop_name', 'Yetie Shop', 'pref.title.shop_name', 'pref.summary.shop_name', 10, 2 ],

        # staff
        [ 'staff_password_min', '8', 'pref.title.staff_password_min', 'pref.summary.staff_password_min', 20, 2 ],
        [ 'staff_password_max', '512', 'pref.title.staff_password_max', 'pref.summary.staff_password_max', 30, 2 ],

        # customer
        [ 'customer_password_min', '8', 'pref.title.customer_password_min', 'pref.summary.customer_password_min', 40, 2 ],
        [ 'customer_password_max', '512', 'pref.title.customer_password_max', 'pref.summary.customer_password_max', 50, 2 ],

        # application
        [ 'admin_uri_prefix', '/admin', 'pref.title.admin_uri_prefix', 'pref.summary.admin_uri_prefix', 10, 9 ],
        [ 'addons_dir', 'addons', 'pref.title.addons_dir', 'pref.summary.addons_dir', 20, 9 ],
        [ 'can_multiple_shipments', 0, 'pref.title.can_multiple_shipments', 'pref.summary.can_multiple_shipments', 30, 9 ],
        [ 'server_session_expires_delta', 3600, 'pref.title.server_session_expires_delta', 'pref.summary.server_session_expires_delta', 40, 9 ],
        [ 'server_session_cookie_expires_delta', 3600 * 24 * 365, 'pref.title.server_session_cookie_expires_delta', 'pref.summary.server_session_cookie_expires_delta', 50, 9 ],
        [ 'cookie_expires_long', 3600 * 24 * 365, 'pref.title.cookie_expires_long', 'pref.summary.cookie_expires_long', 60, 9 ],
    ],

    # tax rules
    'TaxRule' => [
        [ qw/id title tax_rate/],
        [ 1, 'Tax Exemption', 0 ],
    ],
)
