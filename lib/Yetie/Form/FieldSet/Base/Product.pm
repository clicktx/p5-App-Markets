package Yetie::Form::FieldSet::Base::Product;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'product_id' => (
    type        => 'hidden',
    required    => 1,
    filters     => [],
    validations => [qw(uint)],
);

has_field 'title' => (
    type        => 'text',
    required    => 1,
    label       => 'Title',
    validations => [],
);

has_field 'description' => (
    type        => 'textarea',
    required    => 0,
    label       => 'Description',
    validations => [],
);

has_field 'price' => (
    type        => 'text',
    required    => 1,
    label       => 'Price',
    validations => ['number'],
);

has_field 'quantity' => (
    type          => 'text',
    required      => 1,
    label         => 'Quantity',
    default_value => 1,
    filters       => [qw(trim)],
    validations   => [ 'uint', [ min => 1 ] ],
);

has_field 'categories' => (
    type        => 'choice',
    required    => 0,
    label       => 'Categories',
    expanded    => 1,
    multiple    => 1,
    validations => ['uint'],
);

has_field 'primary_category' => (
    type        => 'choice',
    required    => 0,
    label       => 'Primary Category',
    expanded    => 1,
    multiple    => 0,
    validations => ['uint'],
);

1;
