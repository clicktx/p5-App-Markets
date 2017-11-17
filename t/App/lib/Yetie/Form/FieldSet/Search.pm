package Yetie::Form::FieldSet::Search;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field q => (
    type        => 'text',
    placeholder => 'Search Word',
);

1;
