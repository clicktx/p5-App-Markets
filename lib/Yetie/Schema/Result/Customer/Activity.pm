package Yetie::Schema::Result::Customer::Activity;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column customer_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

primary_column activity_id => {
    data_type   => 'BIGINT',
    is_nullable => 0,
};

# Relation
belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  activity => 'Yetie::Schema::Result::Activity',
  { 'foreign.id' => 'self.activity_id' };

1;
