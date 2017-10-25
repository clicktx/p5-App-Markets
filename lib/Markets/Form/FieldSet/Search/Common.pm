package Markets::Form::FieldSet::Search::Common;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field 'p' => (
    type        => 'text',
    validations => ['uint'],
);

has_field 'q' => (
    type        => 'text',
    validations => [],
);

has_field 'sort' => (
    type        => 'text',
    validations => [],
);

has_field 'direction' => (
    type        => 'text',
    validations => [],
);

1;
