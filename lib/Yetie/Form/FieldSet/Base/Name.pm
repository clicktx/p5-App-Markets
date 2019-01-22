package Yetie::Form::FieldSet::Base::Name;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'organization' => (
    type         => 'text',
    required     => 0,
    label        => 'Organization',
    placeholder  => '',
    autocomplete => 'organization',
    filters      => [qw(trim)],
    validations  => [],
    help         => 'Company name, Local business, Educational organization, NGO, etc.',
);

has_field 'personal_name' => (
    type         => 'text',
    required     => 1,
    label        => 'Full Name',
    placeholder  => 'Christian Holst',
    autocomplete => 'name',
    filters      => [qw(trim)],
    validations  => [],
    help         => '',
);

1;
