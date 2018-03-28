package Yetie::Form::FieldSet::Checkout::Address;
use Mojo::Base -strict;
use Yetie::Form::FieldSet::BillingAddress -all;

has_field 'shipments.[].shipping_address.line1' => (
    extends('address#line1'),
    autocomplete => 'shipping address-line1',
    required     => 1,
);

has_field 'shipments.[].shipping_address.line2' => (
    extends('address#line2'),
    autocomplete => 'shipping address-line2',
    required     => 0,
);

1;
