package Markets::Form::Type::Example;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => ( type => 'email', placeholder => 'use@mail.com', label => 'E-mail' );
has_field 'item.[].id' => ( type => 'hidden', label => 'Item ID' );
has_field 'item.[].name' => ( type => 'text', label => 'Item Name', placeholder => 'The Item Name' );
has_field name    => ( type => 'text' );
has_field address => ( type => 'text', label => 'Address', placeholder => 'Silicon Valley' );
has_field note    => ( type => 'textarea', label => 'Note', placeholder => 'Note', cols => 40 );
has_field agreed => ( type => 'checkbox', label => 'I agreed', value => 1);
has_field country => (
    # type    => 'select_multiple',
    label   => 'Country',
    type    => 'choice',
    expanded => 0,
    multiple => 1,
    choices => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ),
    ],
);

has_field country2 => (
    # type    => 'radio_list',
    label   => 'Country2',
    type    => 'choice',
    expanded => 1,
    multiple => 0,
    choices => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ),
    ],
);

has_field country3 => (
    # type    => 'checkbox_list',
    label   => 'Country3',
    type    => 'choice',
    expanded => 1,
    multiple => 1,
    choices => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ),
    ],
);

1;
