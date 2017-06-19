package Markets::Form::Type::Test;
use Mojo::Base -strict;
use Markets::Form::FieldSet;

has_field email => ( type => 'text', placeholder => '', label => 'E-mail' );
has_field 'item.[].id' => ( type => 'text', label => 'Item ' );
has_field name => ( type => 'text' );
has_field address => ( type => 'text' );

1;
