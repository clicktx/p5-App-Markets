package Markets::Schema::Result::Email;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column address => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 0,
};

column is_verified => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

might_have
  customer_email => 'Markets::Schema::Result::Customer::Email',
  { 'foreign.email_id' => 'self.id' };

1;
