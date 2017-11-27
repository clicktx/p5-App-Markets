package Yetie::Form::FieldSet::Cart::Delete;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'target_item_id' => (
    type => 'hidden',
    required => 1,
);

1;
