package Yetie::Schema::Result::Email;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

# NOTE: Column that use index have a max key length is 767 bytes.
unique_column address => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

column is_verified => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

# Relation
might_have
  customer_email => 'Yetie::Schema::Result::CustomerEmail',
  { 'foreign.email_id' => 'self.id' },
  { cascade_delete     => 0 };

has_many
  authentication_requests => 'Yetie::Schema::Result::AuthenticationRequest',
  { 'foreign.email_id' => 'self.id' },
  { cascade_delete     => 0 };

sub to_data {
    my $self = shift;

    return {
        value       => $self->address,
        is_verified => $self->is_verified,
        _in_storage => 1,
    };
}
1;
