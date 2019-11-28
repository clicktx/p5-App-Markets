package Yetie::Schema::Result::CustomerAddress;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Customer;
use Yetie::Schema::Result::Address;

primary_column customer_id => { data_type => Yetie::Schema::Result::Customer->column_info('id')->{data_type} };
primary_column address_id  => { data_type => Yetie::Schema::Result::Address->column_info('id')->{data_type} };

# Relation
belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  address => 'Yetie::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

1;
