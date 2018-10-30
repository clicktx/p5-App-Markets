package Yetie::Form::FieldSet::Account::Email;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => extends('base-email#email');

1;
