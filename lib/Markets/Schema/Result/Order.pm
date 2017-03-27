package Markets::Schema::Result::Order;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_no => {
    data_type   => 'INT',
    is_nullable => 1,
};

column customer_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column billing_address => {
    data_type => 'VARCHAR',
    size      => 255,
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Markets::Schema->TZ,
};

# belongs_to customer => 'Markets::Schema::Result::Customer', { 'foreign.id' => 'self.customer_id'};
# belongs_to customer => 'Markets::Schema::Result::Customer', 'customer_id';

has_many
  shipments => 'Markets::Schema::Result::Order::Shipment',
  { 'foreign.order_id' => 'self.id' };

1;
