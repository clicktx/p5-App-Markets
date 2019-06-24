package Yetie::Schema::Result::CustomerAddress;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column customer_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

primary_column address_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  address => 'Yetie::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

1;
