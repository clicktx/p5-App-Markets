package Markets::Form::FieldSet::Admin::Product;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'title' => (
    type        => 'text',
    label       => 'Title',
    required    => 1,
    validations => [],
);

has_field 'description' => (
    type        => 'textarea',
    label       => 'Description',
    validations => [],
);

has_field 'price' => (
    type        => 'text',
    label       => 'Price',
    validations => ['number'],
);

has_field 'primary_category' => (
    type     => 'choice',
    expanded => 1,
    multiple => 0,
    validations => ['uint'],
);

1;
