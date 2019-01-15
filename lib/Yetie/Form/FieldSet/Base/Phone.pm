package Yetie::Form::FieldSet::Base::Phone;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'phone' => (
    type         => 'tel',
    label        => 'Phone Number',
    placeholder  => '0123456789',
    help         => '',
    autocomplete => 'home tel-national',
    filters      => [qw(trim)],
    validations  => [],
);

1;
