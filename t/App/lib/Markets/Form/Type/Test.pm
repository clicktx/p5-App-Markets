package Markets::Form::Type::Test;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => (
    type        => 'text',
    placeholder => '',
    label       => 'E-mail',
    filters     => [],
    validations => [qw/email/],
);

has_field name => (
    type        => 'text',
    filters     => [],
    validations => [qw//],
);

has_field address => (
    type        => 'text',
    filters     => [],
    validations => [qw//],
);

has_field 'item.[].id' => (
    type        => 'text',
    label       => 'Item ',
    filters     => [],
    validations => [qw//],
);

1;
