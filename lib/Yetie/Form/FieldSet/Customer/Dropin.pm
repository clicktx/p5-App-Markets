package Yetie::Form::FieldSet::Customer::Dropin;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field email => extends('account-login#email');

1;
