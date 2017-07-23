package Markets::Form::FieldSet::Checkout::Address;
use Mojo::Base -strict;
use Markets::Form::FieldSet::Basic;

has_field 'billing_address.line1' => Markets::Form::FieldSet::Basic->schema('address.line1');

has_field 'shipping_address.line1' => Markets::Form::FieldSet::Basic->schema('address.line1');

1;
