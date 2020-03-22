package Yetie::Schema::Result::ShippingCarrierServiceZoneRegion;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::ShippingCarrierServiceZone;
use Yetie::Schema::Result::AddressCountryRegion;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column zone_id => {
    data_type   => Yetie::Schema::Result::ShippingCarrierServiceZone->column_info('id')->{data_type},
    is_nullable => 0,
};

column region_code => Yetie::Schema::Result::AddressCountryRegion->column_info('code');

column position => {
    data_type     => 'INT',
    default_value => 100,
    is_nullable   => 0,
};

# Relation
belongs_to
  zone => 'Yetie::Schema::Result::ShippingCarrierServiceZone',
  { 'foreign.id' => 'self.zone_id' };

belongs_to
  detail => 'Yetie::Schema::Result::AddressCountryRegion',
  { 'foreign.code' => 'self.region_code' };

1;
