package Yetie::Form::FieldSet::Admin::Order::Edit::Item;
use Mojo::Base -strict;
use Yetie::Form::FieldSet::Base::Product;

my $base_class = 'Yetie::Form::FieldSet::Base::Product';

has_field 'item.{}.price' => $base_class->field_info('price');

has_field 'item.{}.quantity' => $base_class->field_info('quantity');

1;
