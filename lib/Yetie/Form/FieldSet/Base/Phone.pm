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

1;
