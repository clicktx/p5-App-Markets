package Yetie::Form::FieldSet::ShippingAddress;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my $address = fieldset('base-address');
has_field 'shipping_address.id' => $address->field_info('id');

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

has_field 'shipping_address.city' => (
    $address->field_info('city'),
    autocomplete => 'section-sent shipping address-level2',
    required     => 1,
);

has_field 'shipping_address.state' => (
    $address->field_info('state'),
    autocomplete => 'section-sent shipping address-level1',
    required     => 1,
);

has_field 'shipping_address.postal_code' => (
    $address->field_info('postal_code'),
    autocomplete => 'section-sent shipping postal-code',
    required     => 1,
);

has_field 'shipping_address.personal_name' => (
    extends('base-name#personal_name'),
    autocomplete => 'section-sent shipping name',
    required     => 1,
);

has_field 'shipping_address.organization' => (
    extends('base-name#organization'),
    autocomplete => 'section-sent shipping organization',
    required     => 0,
);

has_field 'shipping_address.phone' => (
    extends('base-phone#phone'),
    autocomplete => 'section-sent shipping home tel',
    required     => 1,
);

1;
