package Yetie::Form::FieldSet::Account::Login;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => extends('base-email#email');

has_field 'password' => extends('base-password#password');

1;
