package Markets::Form::FieldSet::Admin::Product;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'title' => (
    type        => 'text',
    label       => 'Title',
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
    validations => [],
);

1;
