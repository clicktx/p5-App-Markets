package Markets::Form::FieldSet::Admin::Order::Delete;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'id' => (
    type     => 'hidden',
    required => 1,
);

1;
