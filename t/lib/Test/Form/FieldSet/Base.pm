package Test::Form::FieldSet::Base;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'a' => ();
has_field 'b' => ();
has_field 'c' => ();

1;
