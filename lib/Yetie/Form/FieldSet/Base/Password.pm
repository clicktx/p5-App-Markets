package Yetie::Form::FieldSet::Base::Password;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

my %password_base = (
    type        => 'password',
    required    => 1,
    label       => 'Password',
    placeholder => 'your password',
    filters     => ['trim'],
);

has_field staff_password => (
    %password_base,
    validations => [ [ size => \'staff_password_min', \'staff_password_max' ], ],
    help => sub {
        my $c = shift;
        $c->__x(
            'Must be {min}-{max} characters long.',
            { min => $c->pref('staff_password_min'), max => $c->pref('staff_password_max') },
        );
    },
);

has_field customer_password => (
    %password_base,
    validations => [ [ size => \'customer_password_min', \'customer_password_max' ], ],
    help => sub {
        my $c = shift;
        $c->__x(
            'Must be {min}-{max} characters long.',
            { min => $c->pref('customer_password_min'), max => $c->pref('customer_password_max') },
        );
    },
);

has_field password_again => (
    type           => 'password',
    required       => 1,
    label          => 'Password Again',
    placeholder    => 'password again',
    help           => 'Type Password Again.',
    filters        => [],
    validations    => [ [ equal_to => 'password' ] ],
    error_messages => {
        equal_to => 'The passwords you entered do not much.',
    },
);

1;
