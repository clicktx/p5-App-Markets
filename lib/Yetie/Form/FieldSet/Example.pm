package Yetie::Form::FieldSet::Example;
use Mojo::Base -strict;

# use Yetie::Form::FieldSet::Basic -all;
use Yetie::Form::FieldSet::Base::Address -all;

# use Yetie::Form::FieldSet::Basic -export_field;
# use Yetie::Form::FieldSet::Basic -export_field => [qw(email password password_again)];

# Yetie::Form::FieldSet::Basic->aaa(qw/email password password_again/);
# Yetie::Form::FieldSet::Basic->aaa(); #export all field

# has_field 'foo' => {
#     fieldset('bar')->field_info('baz'),
#     required => 0,
#     default_value => 1,
#     ...
# };

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
    filters     => [qw(trim)],
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

has_field country1 => (

    # type    => 'select',
    label    => 'Country1 select',
    type     => 'choice',
    expanded => 0,
    multiple => 0,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

has_field country2 => (

    # type    => 'select_multiple',
    label    => 'Country2 select multiple',
    type     => 'choice',
    expanded => 0,
    multiple => 1,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', selected => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

has_field country3 => (

    # type    => 'radio_list',
    label    => 'Country3 radio list',
    type     => 'choice',
    expanded => 1,
    multiple => 0,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

has_field country4 => (

    # type    => 'checkbox_list',
    label    => 'Country4 checkbox list',
    type     => 'choice',
    expanded => 1,
    multiple => 1,
    choices  => [
        c( EU => [ [ Germany => 'de' ], [ England => 'en' ] ] ),
        c( Asia => [ [ China => 'cn' ], [ Japan => 'jp', checked => 1 ] ] ),
    ],
    filters     => [],
    validations => [],
);

1;
