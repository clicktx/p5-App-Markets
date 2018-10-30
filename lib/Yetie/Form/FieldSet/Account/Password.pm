package Yetie::Form::FieldSet::Account::Password;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'password' => extends('base-password#customer_password');

1;
