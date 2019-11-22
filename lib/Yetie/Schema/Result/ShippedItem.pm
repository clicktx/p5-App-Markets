package Yetie::Schema::Result::ShippedItem;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;
use Yetie::Schema::Result::SalesOrderItem;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column shipment_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column order_item_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column quantity => Yetie::Schema::Result::SalesOrderItem->column_info('quantity');

# Relation
belongs_to
  shipment => 'Yetie::Schema::Result::Shipment',
  { 'foreign.id' => 'self.shipment_id' };

belongs_to
  order_item => 'Yetie::Schema::Result::SalesOrderItem',
  { 'foreign.id' => 'self.order_item_id' };

1;
