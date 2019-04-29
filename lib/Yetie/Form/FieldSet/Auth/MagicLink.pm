package Yetie::Form::FieldSet::Auth::MagicLink;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field email => extends('base-email#email');

1;
