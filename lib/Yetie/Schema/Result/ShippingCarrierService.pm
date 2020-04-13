package Yetie::Schema::Result::ShippingCarrierService;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::ShippingCarrier;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column carrier_id => {
    data_type   => Yetie::Schema::Result::ShippingCarrier->column_info('id')->{data_type},
    is_nullable => 0,
};

# description, logo, website,
column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

# Relation
belongs_to
  carrier => 'Yetie::Schema::Result::ShippingCarrier',
  { 'foreign.id' => 'self.carrier_id' };

has_many
  zones => 'Yetie::Schema::Result::ShippingCarrierServiceZone',
  { 'foreign.service_id' => 'self.id' },
  { cascade_delete       => 0 };

1;
