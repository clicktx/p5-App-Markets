package Yetie::Schema::Result::ShippingCarrierServiceZoneState;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::ShippingCarrierServiceZone;
use Yetie::Schema::Result::AddressState;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column zone_id => {
    data_type   => Yetie::Schema::Result::ShippingCarrierServiceZone->column_info('id')->{data_type},
    is_nullable => 0,
};

column state_id => {
    data_type   => Yetie::Schema::Result::AddressState->column_info('id')->{data_type},
    is_nullable => 0,
};

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
  state => 'Yetie::Schema::Result::AddressState',
  { 'foreign.id' => 'self.state_id' };

1;
