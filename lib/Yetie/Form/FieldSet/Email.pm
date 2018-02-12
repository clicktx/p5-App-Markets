package Yetie::Form::FieldSet::Email;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => (
    label        => 'Email',
    autocomplete => 'email',
    type         => 'email',
    placeholder  => '',
    help         => '',
    filters      => [qw(trim)],
    validations  => [],
);

1;
