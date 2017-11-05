package Yetie::Form::FieldSet::Checkout::Address;
use Mojo::Base -strict;
use Yetie::Form::FieldSet::Basic;

has_field 'billing_address.line1' => Yetie::Form::FieldSet::Basic->field_info('address.line1');

has_field 'shipping_address.line1' => Yetie::Form::FieldSet::Basic->field_info('address.line1');

1;
