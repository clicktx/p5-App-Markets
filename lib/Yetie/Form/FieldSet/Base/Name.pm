package Yetie::Form::FieldSet::Base::Name;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'personal_name' => (
    type         => 'text',
    label        => 'Full Name',
    autocomplete => 'name',
    placeholder  => 'Christian Holst',
    filters      => [qw(trim)],
    validations  => [],
    help         => '',
);

has_field 'company_name' => (
    type         => 'text',
    label        => 'Company Name',
    autocomplete => 'organization',
    placeholder  => '',
    filters      => [qw(trim)],
    validations  => [],
    help         => '',
);

1;
