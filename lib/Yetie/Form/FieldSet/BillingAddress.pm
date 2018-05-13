package Yetie::Form::FieldSet::BillingAddress;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my $address = fieldset('address');
has_field 'billing_address.id' => $address->field_info('id');

has_field 'billing_address.country_code' => (
    $address->field_info('country_code'),
    autocomplete => 'off',
    required     => 1,
);

has_field 'billing_address.line1' => (
    $address->field_info('line1'),
    autocomplete => 'section-sent billing address-line1',
    required     => 1,
);

has_field 'billing_address.line2' => (
    $address->field_info('line2'),
    autocomplete => 'section-sent billing address-line2',
    required     => 0,
);

has_field 'billing_address.level1' => (
    $address->field_info('level1'),
    autocomplete => 'section-sent billing address-level1',
    required     => 1,
);

has_field 'billing_address.level2' => (
    $address->field_info('level2'),
    autocomplete => 'section-sent billing address-level2',
    required     => 1,
);

has_field 'billing_address.postal_code' => (
    $address->field_info('postal_code'),
    autocomplete => 'section-sent billing postal-code',
    required     => 1,
);

has_field 'billing_address.personal_name' => (
    extends('name#personal_name'),
    autocomplete => 'section-sent billing name',
    required     => 1,
);

has_field 'billing_address.company_name' => (
    extends('name#company_name'),
    autocomplete => 'section-sent billing organization',
    required     => 0,
);

has_field 'billing_address.phone' => (
    extends('phone#home'),
    autocomplete => 'section-sent billing home tel',
    required     => 1,
);

has_field 'billing_address.fax' => (
    extends('phone#fax'),
    autocomplete => 'section-sent billing fax tel',
    required     => 0,
);

has_field 'billing_address.mobile' => (
    extends('phone#mobile'),
    autocomplete => 'section-sent billing mobile tel',
    required     => 0,
);

1;
