package Yetie::Form::FieldSet::Cart::DeleteItem;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'line_num' => (
    type     => 'hidden',
    required => 1,
);

1;
