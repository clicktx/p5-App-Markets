package Yetie::Form::FieldSet::Base::Email;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => (
    type          => 'email',
    required      => 1,
    label         => 'Email',
    default_value => '',
    placeholder   => 'user@domain.com',
    help          => '',
    autocomplete  => 'email',
    filters       => [qw(trim)],
    validations   => [],                  # NOTE: max 64
);

1;
