package Markets::Form::Type::Example;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => ( type => 'email', placeholder => 'use@mail.com', label => 'E-mail' );
has_field 'item.[].id' => ( type => 'hidden', label => 'Item ID' );
has_field 'item.[].name' => ( type => 'text', label => 'Item Name', placeholder => 'panchi' );
has_field name => ( type => 'text' );
has_field address => ( type => 'text', label => 'Address', placeholder => 'Silicon Valley' );

1;
