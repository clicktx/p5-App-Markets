package Yetie::Schema::Result::ShippingFeePrice;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Price;
use Yetie::Schema::Result::ShippingFee;

primary_column price_id => { data_type => Yetie::Schema::Result::Price->column_info('id')->{data_type} };

column shipping_fee_id => {
    data_type   => Yetie::Schema::Result::ShippingFee->column_info('id')->{data_type},
    is_nullable => 0,
};

# Relation
belongs_to
  price => 'Yetie::Schema::Result::Price',
  { 'foreign.id' => 'self.price_id' };

belongs_to
  shipping_fee => 'Yetie::Schema::Result::ShippingFee',
  { 'foreign.id' => 'self.shipping_fee_id' };

1;
