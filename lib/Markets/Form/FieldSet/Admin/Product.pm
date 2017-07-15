package Markets::Form::FieldSet::Admin::Product;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'keywords' => (
    type        => 'text',
    validations => [],
);

1;
