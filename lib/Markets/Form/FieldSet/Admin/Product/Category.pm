package Markets::Form::FieldSet::Admin::Product::Category;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'categories' => (
    type        => 'choice',
    expanded    => 1,
    multiple    => 1,
    validations => ['uint'],
);

1;
