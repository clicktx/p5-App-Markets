package Yetie::Schema::Result::AddressCountry;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column code => {
    data_type => 'VARCHAR',
    size      => 2,
    comments  => 'ISO 3166-1 alpha-2',
};

# AS EU NA SA AU
# column continent => {
#     data_type   => 'VARCHAR',
#     size        => 2,
#     is_nullable => 0,
# };

column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

column position => {
    data_type     => 'INT',
    default_value => 100,
    is_nullable   => 0,
};

# Relation
has_many
  regions => 'Yetie::Schema::Result::AddressCountryRegion',
  { 'foreign.country_code' => 'self.code' },
  { cascade_delete       => 0 };

1;
