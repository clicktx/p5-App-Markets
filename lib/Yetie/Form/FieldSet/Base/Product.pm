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
    label       => 'Title',
    required    => 1,
    validations => [],
);

has_field 'description' => (
    type        => 'textarea',
    label       => 'Description',
    required    => 0,
    validations => [],
);

has_field 'price' => (
    type        => 'text',
    label       => 'Price',
    required    => 1,
    validations => ['number'],
);

has_field 'quantity' => (
    type          => 'text',
    label         => 'Quantity',
    required      => 1,
    default_value => 1,
    filters       => [qw(trim)],
    validations   => [ 'uint', [ min => 1 ] ],
);

has_field 'categories' => (
    type        => 'choice',
    label         => 'Categories',
    required    => 0,
    expanded    => 1,
    multiple    => 1,
    validations => ['uint'],
);

has_field 'primary_category' => (
    type        => 'choice',
    label => 'Primary Category',
    required    => 0,
    expanded    => 1,
    multiple    => 0,
    validations => ['uint'],
);

1;
