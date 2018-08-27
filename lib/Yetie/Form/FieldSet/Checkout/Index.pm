package Yetie::Form::FieldSet::Checkout::Index;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'guest-email' => extends('base-email#email');

1;
