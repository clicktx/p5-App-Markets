package Yetie::Form::FieldSet::Test;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field no_attrs => ();

has_field email => (
    type        => 'email',
    placeholder => 'name@domain',
    label       => 'E-mail',
    required    => 1,
    filters     => [qw(trim)],
    validations => [ [ size => 2, 5 ], [ like => qr/.+@.+\..+/ ] ],
    help        => 'Your email',
);

has_field name => (
    type     => 'text',
    required => 1,

    # not set filters and validations
    # filters     => [],
    # validations => [],
);

has_field nickname => (
    type     => 'text',
    required => 0,
    label    => 'nickname',
);

has_field address => (
    type        => 'text',
    required    => 1,
    filters     => [],
    validations => [],
);

has_field favorite_color => (
    type        => 'choice',
    multiple    => 1,
    expanded    => 1,
    required    => 1,
    filters     => [],
    validations => [],
    choices     => [qw(red green blue yellow black)],
);

has_field luky_number => (
    type        => 'choice',
    multiple    => 1,
    expanded    => 1,
    required    => 1,
    filters     => [],
    validations => [],
    choices     => [qw(1 2 3 4 5 6 7 8 9)],
);

has_field 'item.[].id' => (
    type        => 'text',
    label       => 'Item ',
    required    => 1,
    filters     => [],
    validations => [],
);

has_field 'item.[].name' => (
    type        => 'text',
    label       => 'Item ',
    filters     => [qw/trim/],
    validations => [],
);

has_field 'billing.line1' => ( type => 'text', );

has_field 'billing.line2' => ( type => 'text', );

has_field 'burgers.[].name' => (
    type     => 'text',
    required => 0,
);

has_field 'burgers.[].toppings' => (
    type     => 'choice',
    multiple => 1,
    expanded => 1,
    choices  => [qw(a b c d e)],
);

1;
