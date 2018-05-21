package Yetie::Form::FieldSet::Base::Email;
use Mojo::Base -strict;
use Yetie::Form::FieldSet;

has_field 'email' => (
    type          => 'email',
    label         => 'Email',
    autocomplete  => 'email',
    placeholder   => 'user@domain.com',
    help          => '',
    default_value => '',
    required      => 1,
    filters       => [qw(trim)],
    validations   => [],                  # NOTE: max 64
);

1;
