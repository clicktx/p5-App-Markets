package Markets::Form::FieldSet::Cart;
use Mojo::Base -strict;
use Markets::Form::FieldSet::Product;

has_field 'item.[].quantity' => Markets::Form::FieldSet::Product->schema('quantity');

# has_field 'item.[].quantity' => (
#     type => 'text',
#     # label       => 'Quantity',
#     # default_value => 1,
#     filters     => [qw(trim)],
#     validations => [qw(uint)],
# );

1;
