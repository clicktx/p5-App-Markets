package Yetie::Form::FieldSet::Address;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'line1' => (
    label        => 'Address Line1',
    autocomplete => 'address-line1',
    type         => 'text',
    placeholder  => '2125 Chestnut st',
    help         => 'Street address, P.O. box, company name, c/o',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'line2' => (
    label        => 'Address Line2',
    autocomplete => 'address-line2',
    type         => 'text',
    placeholder  => '(optional)',
    help         => 'Apartment, suite, unit, building, floor, etc.',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'level1' => (
    label        => 'State/Province/Region',
    autocomplete => 'address-level1',
    type         => 'text',
    placeholder  => 'E.g. CA, WA',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'level2' => (
    label        => 'City',
    autocomplete => 'address-level2',
    type         => 'text',
    placeholder  => 'City/Town',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'postal_code' => (
    label        => 'ZIP/Postal code',
    autocomplete => 'postal-code',
    type         => 'text',
    placeholder  => '5 Digits',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

1;
