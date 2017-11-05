package Yetie::Form::FieldSet::Admin::Category::Index;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'title' => (
    type        => 'text',
    label       => 'Category Name',
    required    => 1,
    validations => [],
);

has_field 'parent_id' => (
    type     => 'choice',
    label => 'Parent Category',
    expanded => 0,
    multiple => 0,
    choices  => [],
);

1;
