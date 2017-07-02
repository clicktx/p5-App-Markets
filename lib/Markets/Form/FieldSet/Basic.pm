package Markets::Form::FieldSet::Basic;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => (
    type          => 'email',
    placeholder   => 'use@mail.com',
    label         => 'E-mail',
    default_value => 'a@b',
    required      => 1,
    filters       => [qw(trim)],
    validations   => [],
);

has_field password => (
    type          => 'password',
    placeholder   => 'your password',
    label         => 'Password',
    # required      => 1,
    filters       => [],
    validations   => [],
);

has_field password_again => (
    type        => 'password',
    placeholder => 'password again',
    label       => 'Password Again',
    # required    => 1,
    filters     => [],
    validations => [ { equal_to => 'password' } ],
);

1;
