package Markets::Form::FieldSet::Checkout;
use Mojo::Base -strict;
use Markets::Form::FieldSet::Basic;

has_field 'billing_address.line1' => Markets::Form::FieldSet::Basic->schema('address.line1');

has_field 'shipping_address.line1' => Markets::Form::FieldSet::Basic->schema('address.line1');

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
