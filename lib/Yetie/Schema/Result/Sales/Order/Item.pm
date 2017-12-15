package Yetie::Schema::Result::Sales::Order::Item;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;
use Yetie::Schema::Result::Product;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_title => Yetie::Schema::Result::Product->column_info('title');

# column description => {
#     data_type   => 'VARCHAR',
#     size        => 100,
#     is_nullable => 0,
# };

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
};

column price => Yetie::Schema::Result::Product->column_info('price');

belongs_to
  order => 'Yetie::Schema::Result::Sales::Order',
  { 'foreign.id' => 'self.order_id' };

1;
