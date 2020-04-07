package Yetie::Form::FieldSet::Base::Address;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'id' => (
    type        => 'hidden',
    required    => 0,
    filters     => [qw(trim)],
    validations => [qw(int)],
);

has_field 'country_code' => (
    type         => 'choice',
    required     => 1,
    label        => 'Country',
    help         => '',
    autocomplete => 'off',
    filters      => [qw(trim)],
    validations  => [],
    expanded     => 0,
    multiple     => 0,
    choices      => [
        c( Americas       => [ [ Canada  => 'CA' ], [ 'United States' => 'US' ] ] ),
        c( 'Asia Pacific' => [ [ China   => 'CN' ], [ Japan           => 'JP' ] ] ),
        c( EU             => [ [ England => 'EN' ], [ Germany         => 'DE' ] ] ),
        c( Africa         => [ [ Nigeria => 'NG' ], [ 'South Africa'  => 'ZA' ] ] ),
    ],
);

has_field 'line1' => (
    type         => 'text',
    required     => 1,
    label        => 'Address Line1',
    placeholder  => '2125 Chestnut st',
    help         => 'Street address, P.O. box, c/o',
    autocomplete => 'address-level3',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'line2' => (
    type         => 'text',
    required     => 0,
    label        => 'Address Line2',
    placeholder  => '(optional)',
    help         => 'Apartment, suite, unit, building, floor, etc.',
    autocomplete => 'address-level4',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'city' => (
    type         => 'text',
    required     => 1,
    label        => 'City',
    placeholder  => 'City/Town',
    help         => '',
    autocomplete => 'address-level2',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'state' => (
    type         => 'text',
    required     => 1,
    label        => 'State/Province/Region',
    placeholder  => 'E.g. CA, WA',
    help         => '',
    autocomplete => 'address-level1',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'postal_code' => (
    type         => 'text',
    required     => 1,
    label        => 'ZIP/Postal code',
    placeholder  => '5 Digits',
    help         => '',
    autocomplete => 'postal-code',
    filters      => [qw(trim)],
    validations  => [],
);

1;
