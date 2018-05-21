package Yetie::Form::FieldSet::Admin::Product;
use Mojo::Base -strict;
use Yetie::Form::FieldSet::Base::Product;

my $base_class = 'Yetie::Form::FieldSet::Base::Product';

has_field 'title' => $base_class->field_info('title');

has_field 'description' => $base_class->field_info('description');

has_field 'price' => $base_class->field_info('price');

has_field 'primary_category' => $base_class->field_info('primary_category');

1;
