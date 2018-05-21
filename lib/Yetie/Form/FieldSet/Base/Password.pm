package Yetie::Form::FieldSet::Base::Password;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field password => (
    type        => 'password',
    label       => 'Password',
    placeholder => 'your password',
    required    => 1,
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
    type           => 'password',
    label          => 'Password Again',
    placeholder    => 'password again',
    required       => 1,
    filters        => [],
    validations    => [ [ equal_to => 'password' ] ],
    help           => 'Type Password Again.',
    error_messages => {
        equal_to => 'The passwords you entered do not much.',
    },
);

1;
