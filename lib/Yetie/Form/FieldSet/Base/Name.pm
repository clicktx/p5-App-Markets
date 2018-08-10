package Yetie::Form::FieldSet::Base::Name;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'organization' => (
    type         => 'text',
    label        => 'Organization',
    autocomplete => 'organization',
    placeholder  => '',
    filters      => [qw(trim)],
    validations  => [],
    help         => 'Company name, Local business, Educational organization, NGO, etc.',
);

has_field 'personal_name' => (
    type         => 'text',
    label        => 'Full Name',
    autocomplete => 'name',
    placeholder  => 'Christian Holst',
    filters      => [qw(trim)],
    validations  => [],
    help         => '',
);

1;
