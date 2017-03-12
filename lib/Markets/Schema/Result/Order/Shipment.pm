package Markets::Schema::Result::Order::Shipment;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

# belongs_to
#   order => 'Markets::Schema::Result::Order',
#   { 'foreign.id' => 'self.order_id' };

belongs_to order => 'Markets::Schema::Result::Order', 'order_id';

has_many
  items => 'Markets::Schema::Result::Order::Shipment::Item',
  { 'foreign.shipment_id' => 'self.id' };

1;
