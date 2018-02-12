package Yetie::Form::FieldSet::BillingAddress;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'name' => (
    extends('name#personal_name'),
    autocomplete => 'section-sent billing name',
    required     => 1,
);

# fieldset('address')->export_field;
my $address = fieldset('address');
has_field 'line1' => (
    $address->field_info('line1'),
    autocomplete => 'section-sent billing address-line1',
    required     => 1,
);

has_field 'line2' => (
    $address->field_info('line2'),
    autocomplete => 'section-sent billing address-line2',
    required     => 0,
);

has_field 'city' => (
    $address->field_info('city'),
    autocomplete => 'section-sent billing city',
    required     => 1,
);

has_field 'state' => (
    $address->field_info('state'),
    autocomplete => 'section-sent billing state',
    required     => 1,
);

has_field 'postal_code' => (
    $address->field_info('postal_code'),
    autocomplete => 'section-sent billing postal-code',
    required     => 1,
);

has_field 'phone' => (
    fieldset('phone')->field_info('home'),
    autocomplete => 'section-sent billing home tel',
    required     => 1,
);

has_field 'fax' => (
    fieldset('phone')->field_info('fax'),
    autocomplete => 'section-sent billing fax tel',
    required     => 0,
);

has_field 'mobile' => (
    fieldset('phone')->field_info('mobile'),
    autocomplete => 'section-sent billing mobile tel',
    required     => 0,
);

has_field 'email' => (
    extends 'email#email',
    autocomplete => 'section-sent billing email',
    required     => 1,
);

1;
