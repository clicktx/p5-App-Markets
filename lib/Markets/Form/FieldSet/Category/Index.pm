package Markets::Form::FieldSet::Category::Index;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'page' => (
    type        => 'text',
    validations => ['uint'],
);

has_field 'keywords' => (
    type        => 'text',
    validations => [],
);

1;
