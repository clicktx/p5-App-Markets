package Yetie::Form::FieldSet::Admin::Product::Category;
use Mojo::Base -strict;
use Yetie::Form::FieldSet::Base::Product;

my $base_class = 'Yetie::Form::FieldSet::Base::Product';

has_field 'categories' => $base_class->field_info('categories');

1;
