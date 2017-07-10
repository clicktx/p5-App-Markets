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
    type        => 'password',
    placeholder => 'your password',
    label       => 'Password',

    # required      => 1,
    filters     => [],
    validations => [ [ size => \'customer_password_min', \'customer_password_max' ], ],
    help        => sub {
        my $c = shift;
        $c->__x(
            'Must be {min}-{max} characters long.',
            { min => $c->pref('customer_password_min'), max => $c->pref('customer_password_max') },
        );
    },
);

has_field password_again => (
    type        => 'password',
    placeholder => 'password again',
    label       => 'Password Again',

    # required    => 1,
    filters        => [],
    validations    => [ [ equal_to => 'password' ] ],
    help           => 'Type Password Again.',
    error_messages => {
        equal_to => 'The passwords you entered do not much.',
    },
);

1;
