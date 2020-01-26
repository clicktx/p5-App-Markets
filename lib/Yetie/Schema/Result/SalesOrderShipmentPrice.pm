package Yetie::Schema::Result::SalesOrderShipmentPrice;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::SalesPrice;
use Yetie::Schema::Result::SalesOrderShipment;

primary_column price_id => { data_type => Yetie::Schema::Result::SalesPrice->column_info('id')->{data_type}, };

column shipment_id => {
    data_type   => Yetie::Schema::Result::SalesOrderShipment->column_info('id')->{data_type},
    is_nullable => 0,
};

# Relation
belongs_to
  price => 'Yetie::Schema::Result::SalesPrice',
  { 'foreign.id' => 'self.price_id' };

belongs_to
  shipment => 'Yetie::Schema::Result::SalesOrderShipment',
  { 'foreign.id' => 'self.shipment_id' };

sub to_data {
    my $self = shift;
    return $self->price->to_data;
}

1;
