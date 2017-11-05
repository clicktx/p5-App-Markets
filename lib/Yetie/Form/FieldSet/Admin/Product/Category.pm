package Yetie::Form::FieldSet::Admin::Product::Category;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'categories' => (
    type        => 'choice',
    expanded    => 1,
    multiple    => 1,
    validations => ['uint'],
);

1;
