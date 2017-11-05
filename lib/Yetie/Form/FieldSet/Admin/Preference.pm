package Yetie::Form::FieldSet::Admin::Preference;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'admin_uri_prefix' => (
    type        => 'text',
    validations => [],
);

has_field 'addons_dir' => (
    type        => 'text',
    validations => [],
);

has_field 'locale_country' => (
    type        => 'text',
    validations => [],
);

has_field 'shop_name' => (
    type        => 'text',
    validations => [],
);

has_field 'customer_password_min' => (
    type        => 'number',
    validations => ['int'],
);

has_field 'customer_password_max' => (
    type        => 'number',
    validations => ['int'],
);

1;
