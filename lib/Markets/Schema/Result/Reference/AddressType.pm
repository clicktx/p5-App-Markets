package Markets::Schema::Result::Reference::AddressType;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column type => {
    data_type => 'CHAR',
    size      => 4,
};

has_many customer_addresses => 'Markets::Schema::Result::Customer::Address', 'type';

1;
