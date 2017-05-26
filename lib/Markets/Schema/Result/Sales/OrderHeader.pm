package Markets::Schema::Result::Sales::OrderHeader;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column customer_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column address_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

belongs_to
  customer => 'Markets::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  billing_address => 'Markets::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

has_many
  shipments => 'Markets::Schema::Result::Sales::Order::Shipment',
  { 'foreign.order_header_id' => 'self.id' };

1;
