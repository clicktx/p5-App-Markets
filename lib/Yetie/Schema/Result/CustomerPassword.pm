package Yetie::Schema::Result::CustomerPassword;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Customer;
use Yetie::Schema::Result::Password;

primary_column password_id => { data_type => Yetie::Schema::Result::Password->column_info('id')->{data_type} };

column customer_id => {
    data_type   => Yetie::Schema::Result::Customer->column_info('id')->{data_type},
    is_nullable => 0,
};

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
        value      => $self->password->hash,
        created_at => $self->password->created_at,
    };
}

1;
