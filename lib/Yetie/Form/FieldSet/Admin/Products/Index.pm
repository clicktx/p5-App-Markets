package Yetie::Form::FieldSet::Admin::Products::Index;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'p' => (
    type        => 'text',
    validations => ['uint'],
);

has_field 'q' => (
    type        => 'text',
    validations => [],
);

1;