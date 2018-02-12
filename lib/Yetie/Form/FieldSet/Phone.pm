package Yetie::Form::FieldSet::Phone;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'home' => (
    label        => 'Phone Number',
    autocomplete => 'home tel',
    type         => 'tel',
    placeholder  => '555-555-5555',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'work' => (
    label        => 'Phone Number',
    autocomplete => 'work tel',
    type         => 'tel',
    placeholder  => '555-555-5555',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'mobile' => (
    label        => 'Mobile Phone',
    autocomplete => 'mobile tel',
    type         => 'tel',
    placeholder  => '(optional)',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'fax' => (
    label        => 'FAX',
    autocomplete => 'fax tel',
    type         => 'tel',
    placeholder  => '(optional)',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

1;
