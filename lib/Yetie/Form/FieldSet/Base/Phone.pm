package Yetie::Form::FieldSet::Base::Phone;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'phone' => (
    type         => 'tel',
    label        => 'Phone Number',
    autocomplete => 'home tel-national',
    placeholder  => '0123456789',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'fax' => (
    type         => 'tel',
    label        => 'FAX',
    autocomplete => 'fax tel-national',
    placeholder  => '(optional)',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

has_field 'mobile' => (
    type         => 'tel',
    label        => 'Mobile Phone',
    autocomplete => 'mobile tel-national',
    placeholder  => '(optional)',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

1;
