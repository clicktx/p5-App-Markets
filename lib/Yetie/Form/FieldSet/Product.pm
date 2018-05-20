package Yetie::Form::FieldSet::Product;
use Mojo::Base -strict;
use Yetie::Form::FieldSet::Base::Product;

my $base_class = 'Yetie::Form::FieldSet::Base::Product';

has_field 'product_id' => $base_class->field_info('product_id');

has_field 'quantity' => $base_class->field_info('quantity');

1;
