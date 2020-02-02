package Yetie::Schema::Result::ShippingZone;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::AddressCountry;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column country_code => Yetie::Schema::Result::AddressCountry->column_info('code');

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
belongs_to
  country => 'Yetie::Schema::Result::AddressCountry',
  { 'foreign.code' => 'self.country_code' };

has_many
  subdivisions => 'Yetie::Schema::Result::ShippingZoneSubdivision',
  { 'foreign.zone_id' => 'self.id' },
  { cascade_delete            => 0 };

1;
