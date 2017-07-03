package Markets::Form::FieldSet::Basic;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

our $password_low  = 4;
our $password_high = 8;

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
    type        => 'password',
    placeholder => 'your password',
    label       => 'Password',

    # required      => 1,
    filters     => [],
    validations => [],
    help        => sub {
        shift->__x( 'Must be {low}-{high} characters long.', { low => $password_low, high => $password_high }, );
    },
);

has_field password_again => (
    type        => 'password',
    placeholder => 'password again',
    label       => 'Password Again',

    # required    => 1,
    filters        => [],
    validations    => [ { equal_to => 'password' } ],
    help           => 'Type Password Again.',
    error_messages => {
        equal_to => 'The passwords you entered do not much.',
    },
);

1;
