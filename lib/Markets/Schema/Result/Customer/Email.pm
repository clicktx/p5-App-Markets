package Markets::Schema::Result::Customer::Email;
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

column email_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column is_primary => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

unique_constraint ui_customer_id_email_id => [qw/customer_id email_id/];

belongs_to
  customer => 'Markets::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  email => 'Markets::Schema::Result::Email',
  { 'foreign.id' => 'self.email_id' };

1;
