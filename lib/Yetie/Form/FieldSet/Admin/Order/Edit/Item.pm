package Yetie::Form::FieldSet::Admin::Order::Edit::Item;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my $product = fieldset('base-product');

has_field 'item.{}.price' => $product->field_info('price');

has_field 'item.{}.quantity' => $product->field_info('quantity');

1;
