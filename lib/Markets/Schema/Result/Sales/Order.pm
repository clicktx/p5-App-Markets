package Markets::Schema::Result::Sales::Order;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_number => {
    data_type   => 'INT',
    is_nullable => 1,
};

column billing_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column shipping_address => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Markets::Schema->TZ,
};

belongs_to billing => 'Markets::Schema::Result::Sales::Order::Billing', 'billing_id';

has_many
  items => 'Markets::Schema::Result::Sales::Order::Item',
  { 'foreign.order_id' => 'self.id' };

1;
