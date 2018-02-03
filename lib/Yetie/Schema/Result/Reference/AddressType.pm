package Yetie::Schema::Result::Reference::AddressType;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column type => {
    data_type => 'CHAR',
    size      => 4,
};

has_many
  customer_addresses => 'Yetie::Schema::Result::Customer::Address',
  'type',
  { cascade_delete => 0 };

1;
