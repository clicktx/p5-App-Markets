package Markets::Form::Type::Example;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => ( type => 'email', placeholder => 'use@mail.com', label => 'E-mail' );
has_field 'item.[].id' => ( type => 'hidden', label => 'Item ID' );
has_field 'item.[].name' => ( type => 'text', label => 'Item Name', placeholder => 'The Item Name' );
has_field name    => ( type => 'text' );
has_field address => ( type => 'text', label => 'Address', placeholder => 'Silicon Valley' );
has_field note    => ( type => 'textarea', label => 'Note', placeholder => 'Note', cols => 40 );
has_field country => (
    type    => 'select',
    label   => 'Country',
    choices => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ),
    ],
);

1;
