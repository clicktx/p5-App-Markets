package Yetie::Form::FieldSet::Name;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'personal_name' => (
    label        => 'Full Name',
    autocomplete => 'name',
    type         => 'text',
    placeholder  => 'Christian Holst',
    filters      => [qw(trim)],
    validations  => [],
    help         => '',
);

has_field 'company_name' => (
    label        => 'Company Name',
    autocomplete => 'organization',
    type         => 'text',
    placeholder  => '',
    filters      => [qw(trim)],
    validations  => [],
    help         => '',
);

1;
