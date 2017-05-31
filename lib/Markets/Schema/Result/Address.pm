package Markets::Schema::Result::Address;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column line1 => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 0,
};

has_many
  customer_addresses => 'Markets::Schema::Result::Customer::Address',
  { 'foreign.address_id' => 'self.id' };

has_many
  order_headers => 'Markets::Schema::Result::Sales::OrderHeader',
  { 'foreign.address_id' => 'self.id' };

has_many
  shipments => 'Markets::Schema::Result::Sales::Order::Shipment',
  { 'foreign.address_id' => 'self.id' };

1;