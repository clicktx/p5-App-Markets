package Yetie::Schema::Result::ShippingCarrierServiceZone;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::ShippingCarrierService;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column service_id => {
    data_type   => Yetie::Schema::Result::ShippingCarrierService->column_info('id')->{data_type},
    is_nullable => 0,
};

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
  service => 'Yetie::Schema::Result::ShippingCarrierService',
  { 'foreign.id' => 'self.service_id' };

# 価格履歴を記録するためhas_manyを使用
has_many
  shipping_fees => 'Yetie::Schema::Result::ShippingFee',
  { 'foreign.zone_id' => 'self.id' },
  { cascade_delete            => 0 };

1;
