package Markets::Schema::Result::Sales::Order::Shipment;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_header_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column address_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

# NOTE: 'order' is SQL reserved word.
belongs_to
  order_header => 'Markets::Schema::Result::Sales::OrderHeader',
  { 'foreign.id' => 'self.order_header_id' };

belongs_to
  shipping_address => 'Markets::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

has_many
  shipping_items => 'Markets::Schema::Result::Sales::Order::Shipment::Item',
  { 'foreign.shipment_id' => 'self.id' };

1;
