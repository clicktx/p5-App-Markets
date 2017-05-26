package Markets::Schema::Result::Customer;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column password_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

belongs_to
  password => 'Markets::Schema::Result::Password',
  { 'foreign.id' => 'self.password_id' };

has_many
  emails => 'Markets::Schema::Result::Customer::Email',
  { 'foreign.customer_id' => 'self.id' };

has_many
  addresses => 'Markets::Schema::Result::Customer::Address',
  { 'foreign.customer_id' => 'self.id' };

has_many
  order_headers => 'Markets::Schema::Result::Sales::OrderHeader',
  { 'foreign.customer_id' => 'self.id' };

1;
