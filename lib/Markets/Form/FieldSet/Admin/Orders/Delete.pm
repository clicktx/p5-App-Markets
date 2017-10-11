package Markets::Form::FieldSet::Admin::Orders::Delete;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'id' => (
    type        => 'hidden',
    required    => 1,
);

1;
