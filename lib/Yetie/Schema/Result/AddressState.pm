package Yetie::Schema::Result::AddressState;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::AddressCountry;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column country_code => {

    %{ Yetie::Schema::Result::AddressCountry->column_info('code') },
    is_nullable => 0,
};

column code => {
    data_type => 'VARCHAR',
    size      => 8,
    comments  => 'ISO 3166-2',
};

column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

# column postal_regex => {
#     data_type   => 'VARCHAR',
#     size        => 64,
#     is_nullable => 1,
# };

# NOTE: 緯度経度を扱うにはMySQL5.7以上が推奨？
# latitude
# longitude

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
  carrier_service_regions => 'Yetie::Schema::Result::ShippingCarrierServiceZoneState',
  { 'foreign.state_id' => 'self.id' },
  { cascade_delete      => 0 };

1;
