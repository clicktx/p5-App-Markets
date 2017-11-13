package Yetie::Form::FieldSet::Admin::Category;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'title' => (
    type        => 'text',
    label       => 'Category Name',
    required    => 1,
    validations => [],
    error_messages => {
        duplicate_title => 'A category with the same name exists.',
    },
);

has_field 'parent_id' => (
    type     => 'choice',
    label => 'Parent Category',
    expanded => 0,
    multiple => 0,
    choices  => [],
);

1;
