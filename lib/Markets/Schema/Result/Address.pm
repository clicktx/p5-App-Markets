package Markets::Schema::Result::Address;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column line1 => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 0,
};

# belongs_to
#   customer_address => 'Markets::Schema::Result::Customer::Address',
#   { 'foreign.id' => 'self.customer_address_id' };

1;
