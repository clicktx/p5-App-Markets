package Yetie::Form::FieldSet::Checkout::SelectAddress;
use Yetie::Form::FieldSet;

has_field 'select_no' => (
    filters     => [qw(trim)],
    validations => [qw(uint)],
);

1;
