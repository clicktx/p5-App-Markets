package Yetie::Form::FieldSet::Product;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my $product = fieldset('base-product');

has_field 'product_id' => $product->field_info('product_id');

has_field 'quantity' => $product->field_info('quantity');

1;
