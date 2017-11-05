package Yetie::Form::FieldSet::Admin::Order::Delete;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'id' => (
    type     => 'hidden',
    required => 1,
);

1;
