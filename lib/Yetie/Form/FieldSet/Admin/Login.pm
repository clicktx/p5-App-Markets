package Yetie::Form::FieldSet::Admin::Login;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'login_id' => extends('base-staff#login_id');

has_field 'password' => extends('base-password#staff_password');

1;
