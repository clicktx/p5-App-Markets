package Yetie::Schema::Result::Sales::Order;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column sales_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column address_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

belongs_to
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.id' => 'self.sales_id' };

belongs_to
  shipping_address => 'Yetie::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

has_many
  items => 'Yetie::Schema::Result::Sales::Order::Item',
  { 'foreign.order_id' => 'self.id' },
  { cascade_delete     => 0 };

1;
