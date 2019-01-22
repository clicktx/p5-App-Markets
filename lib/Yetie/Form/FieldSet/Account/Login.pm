package Yetie::Form::FieldSet::Account::Login;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field email => extends('base-email#email');

has_field password => extends('base-password#customer_password');

has_field remember_me => (
    type  => 'checkbox',
    label => 'Remember me',
    value => 1,
);

1;
