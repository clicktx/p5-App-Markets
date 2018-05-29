package Yetie::Schema::Result::Customer::Password;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column customer_id => { data_type => 'INT' };

column password_id => { data_type => 'INT' };

# Relation
belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  password => 'Yetie::Schema::Result::Password',
  { 'foreign.id' => 'self.password_id' };

sub to_data {
    my $self = shift;

    return {
        id         => $self->customer_id,
        hash       => $self->password->hash,
        created_at => $self->password->created_at,
        updated_at => $self->password->updated_at,
    };
}

1;
