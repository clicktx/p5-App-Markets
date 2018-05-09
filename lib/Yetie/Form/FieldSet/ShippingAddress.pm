package Yetie::Form::FieldSet::ShippingAddress;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my $address = fieldset('address');
has_field 'shipping_address.country_code' => (
    $address->field_info('country_code'),
    autocomplete => 'off',
    required     => 1,
);

has_field 'shipping_address.line1' => (
    $address->field_info('line1'),
    autocomplete => 'section-sent shipping address-line1',
    required     => 1,
);

has_field 'shipping_address.line2' => (
    $address->field_info('line2'),
    autocomplete => 'section-sent shipping address-line2',
    required     => 0,
);

has_field 'shipping_address.level1' => (
    $address->field_info('level1'),
    autocomplete => 'section-sent shipping address-level1',
    required     => 1,
);

has_field 'shipping_address.level2' => (
    $address->field_info('level2'),
    autocomplete => 'section-sent shipping address-level2',
    required     => 1,
);

has_field 'shipping_address.postal_code' => (
    $address->field_info('postal_code'),
    autocomplete => 'section-sent shipping postal-code',
    required     => 1,
);

has_field 'shipping_address.personal_name' => (
    extends('name#personal_name'),
    autocomplete => 'section-sent shipping name',
    required     => 1,
);

has_field 'shipping_address.company_name' => (
    extends('name#company_name'),
    autocomplete => 'section-sent shipping organization',
    required     => 0,
);

has_field 'shipping_address.phone' => (
    extends('phone#home'),
    autocomplete => 'section-sent shipping home tel',
    required     => 1,
);

has_field 'shipping_address.fax' => (
    extends('phone#fax'),
    autocomplete => 'section-sent shipping fax tel',
    required     => 0,
);

has_field 'shipping_address.mobile' => (
    extends('phone#mobile'),
    autocomplete => 'section-sent shipping mobile tel',
    required     => 0,
);

1;
