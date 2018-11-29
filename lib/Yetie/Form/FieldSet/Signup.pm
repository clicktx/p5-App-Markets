package Yetie::Form::FieldSet::Signup;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => extends('base-email#email');

1;
