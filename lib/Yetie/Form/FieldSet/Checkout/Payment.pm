package Yetie::Form::FieldSet::Checkout::Payment;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'payment_method' => (
    type         => 'choice',
    required     => 1,
    label        => 'Payment Methods',
    help         => '',
    autocomplete => 'off',
    filters      => [qw(trim)],
    validations  => [],
    expanded     => 1,
    multiple     => 0,
    choices      => [],
);

1;
