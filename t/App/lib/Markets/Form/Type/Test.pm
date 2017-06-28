package Markets::Form::Type::Test;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => (
    type        => 'text',
    placeholder => '',
    label       => 'E-mail',
    required    => 1,
    filters     => [],
    validations => [ { size => [ 2, 5 ] }, { like => qr/.+@.+\..+/ } ],
);

has_field name => (
    type     => 'text',
    required => 1,

    # not set filters and validations
    # filters     => [],
    validations => [qw//],
);

has_field address => (
    type        => 'text',
    required    => 1,
    filters     => [],
    validations => [qw//],
);

has_field 'item.[].id' => (
    type        => 'text',
    label       => 'Item ',
    required    => 1,
    filters     => [],
    validations => [qw//],
);

has_field 'item.[].name' => (
    type        => 'text',
    label       => 'Item ',
    filters     => [qw/trim/],
    validations => [qw//],
);

1;
