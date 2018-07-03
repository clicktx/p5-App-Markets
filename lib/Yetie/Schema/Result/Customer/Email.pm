package Yetie::Schema::Result::Customer::Email;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column customer_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

primary_column email_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column is_primary => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  email => 'Yetie::Schema::Result::Email',
  { 'foreign.id' => 'self.email_id' };

1;
