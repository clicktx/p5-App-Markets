package Markets::Schema::Result::Sales::Order::Billing;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column customer_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column billing_address => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 0,
};

# column created_at => {
#     data_type   => 'DATETIME',
#     is_nullable => 0,
#     timezone    => Markets::Schema->TZ,
# };

# has_many
#   orders => 'Markets::Schema::Result::Sales::Order',
#   { 'foreign.billing_id' => 'self.id' };
has_many orders => 'Markets::Schema::Result::Sales::Order', 'billing_id';

1;
