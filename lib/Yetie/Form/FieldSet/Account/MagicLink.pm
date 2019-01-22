package Yetie::Form::FieldSet::Account::MagicLink;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field email => extends('account-login#email');

has_field remember_me => extends('account-login#remember_me');

1;
