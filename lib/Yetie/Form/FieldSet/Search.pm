package Yetie::Form::FieldSet::Search;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'page' => (
    type        => 'text',
    validations => ['uint'],
);

has_field 'per_page' => (
    type        => 'text',
    validations => ['uint'],
);

has_field 'q' => (
    type        => 'text',
    validations => [],
);

has_field 'sort' => (
    type        => 'text',
    validations => [],
);

has_field 'order' => (
    type        => 'text',
    validations => [],
);

1;
