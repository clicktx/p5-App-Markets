package Yetie::Form::FieldSet::Base::Staff;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field login_id => (
    type        => 'text',
    required    => 1,
    label       => 'Login ID',
    placeholder => 'Your account ID',
    filters     => [qw(trim)],
    validations => [ 'ascii', [ size => 4, 64 ], [ like => qr/\D/ ] ],
    error_messages => { like => 'Please include at least one alphabet.' },
);

1;
