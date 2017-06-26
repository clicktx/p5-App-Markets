package Markets::Form::Type::Test;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => (
    type        => 'text',
    placeholder => '',
    label       => 'E-mail',
    filters     => [],
    validations => [qw/required email/],
);

has_field name => (
    type        => 'text',
    filters     => [],
    validations => [qw/required/],
);

has_field address => (
    type        => 'text',
    filters     => [],
    validations => [qw/required/],
);

has_field 'item.[].id' => (
    type        => 'text',
    label       => 'Item ',
    filters     => [],
    validations => [qw/required/],
);

1;
