package Yetie::Schema::Result::AddressCountry;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column code => {
    data_type => 'VARCHAR',
    size      => 2,
    comments  => 'ISO 3166-1 alpha-2',
};

column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

1;
