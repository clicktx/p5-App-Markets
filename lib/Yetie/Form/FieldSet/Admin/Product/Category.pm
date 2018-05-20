package Yetie::Form::FieldSet::Admin::Product::Category;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my $product = fieldset('base-product');

has_field 'categories' => $product->field_info('categories');

1;
