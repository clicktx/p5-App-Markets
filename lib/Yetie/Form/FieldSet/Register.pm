package Yetie::Form::FieldSet::Register;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => extends('base-email#email');

has_field 'password' => extends('base-password#customer_password');

has_field 'password_again' => extends('base-password#password_again');

1;
