package Yetie::Schema::Result::Customer::Address;
use Mojo::Base 'Yetie::Schema::Base::Result';
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

column type => {
    data_type   => 'CHAR',
    size        => 4,
    is_nullable => 0,
};

unique_constraint ui_customer_id_address_id_type => [qw/customer_id address_id type/];

belongs_to type => 'Yetie::Schema::Result::Reference::AddressType';

belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  address => 'Yetie::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

1;
