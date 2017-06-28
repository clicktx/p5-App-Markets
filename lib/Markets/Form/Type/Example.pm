package Markets::Form::Type::Example;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => (
    type          => 'email',
    placeholder   => 'use@mail.com',
    label         => 'E-mail',
    default_value => 'a@b',
    required      => 1,
    filters       => [],
    validations   => [],
);

has_field password => (
    type          => 'password',
    placeholder   => 'your password',
    label         => 'Password',
    default_value => '1111',            # bad!
    required      => 1,
    filters       => [],
    validations   => [],
);

has_field password_again => (
    type        => 'password',
    placeholder => 'password again',
    label       => 'Password Again',
    required    => 1,
    filters     => [],
    validations => [ { equal_to => 'password' } ],
);

has_field 'item.[].id' => (
    type        => 'hidden',
    label       => 'Item ID',
    filters     => [],
    validations => [],
);

has_field 'item.[].name' => (
    type        => 'text',
    label       => 'Item Name',
    placeholder => 'The Item Name',
    filters     => [],
    validations => [],
);

has_field name => (
    type        => 'text',
    filters     => [],
    validations => [],
);

has_field address => (
    type        => 'text',
    label       => 'Address',
    placeholder => 'Silicon Valley',
    filters     => [],
    validations => [],
);

has_field note => (
    type          => 'textarea',
    label         => 'Note',
    placeholder   => 'Note',
    cols          => 40,
    default_value => 'This is note',
    filters       => [],
    validations   => [],
);

has_field agreed => (
    type        => 'checkbox',
    label       => 'I agreed',
    value       => 1,
    filters     => [],
    validations => [],
);

has_field country => (

    # type    => 'select_multiple',
    label    => 'Country',
    type     => 'choice',
    expanded => 0,
    multiple => 1,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

has_field country2 => (

    # type    => 'radio_list',
    label    => 'Country2',
    type     => 'choice',
    expanded => 1,
    multiple => 0,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

has_field country3 => (

    # type    => 'checkbox_list',
    label    => 'Country3',
    type     => 'choice',
    expanded => 1,
    multiple => 1,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ Chaina => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

1;
