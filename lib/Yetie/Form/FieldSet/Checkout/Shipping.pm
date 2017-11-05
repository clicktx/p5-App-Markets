package Yetie::Form::FieldSet::Checkout::Shipping;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'is_multiple_shipments' => (
    type        => 'choice',
    label       => 'Multiple Shipments',
    type        => 'choice',
    expanded    => 1,
    multiple    => 0,
    choices     => [ [ Yes => 1 ], [ No => 0, checked => 1 ] ],
    filters     => [],
    validations => [],
);

1;
