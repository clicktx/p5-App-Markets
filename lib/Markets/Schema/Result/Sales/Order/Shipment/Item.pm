package Markets::Schema::Result::Sales::Order::Shipment::Item;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;
use Markets::Schema::Result::Product;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column shipment_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_title => Markets::Schema::Result::Product->column_info('title');

# column description => {
#     data_type   => 'VARCHAR',
#     size        => 100,
#     is_nullable => 0,
# };

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
};

column price => Markets::Schema::Result::Product->column_info('price');

belongs_to
  shipment => 'Markets::Schema::Result::Sales::Order::Shipment',
  { 'foreign.id' => 'self.shipment_id' };

1;
