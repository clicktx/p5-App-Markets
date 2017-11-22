package Yetie::Form::FieldSet::Product;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'product_id' => (
    type        => 'hidden',
    filters     => [],
    validations => [qw(uint)],
);

has_field 'quantity' => (
    type          => 'text',
    label         => 'Quantity',
    default_value => 1,
    filters       => [qw(trim)],
    validations   => [ 'uint', [ min => 1 ] ],
);

has_field 'categories' => (
    type        => 'choice',
    expanded    => 1,
    multiple    => 1,
    validations => ['uint'],
);

1;
