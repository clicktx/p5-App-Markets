package Yetie::Schema::Result::ShippingFee;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::ShippingCarrierServiceZone;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column zone_id => {
    data_type   => Yetie::Schema::Result::ShippingCarrierServiceZone->column_info('id')->{data_type},
    is_nullable => 0,
};

# column created_at => {
#     data_type   => 'DATETIME',
#     is_nullable => 0,
#     timezone    => Yetie::Schema->TZ,
# };

# column updated_at => {
#     data_type   => 'DATETIME',
#     is_nullable => 1,
#     timezone    => Yetie::Schema->TZ,
# };

# Relation
belongs_to
  zone => 'Yetie::Schema::Result::ShippingCarrierServiceZone',
  { 'foreign.id' => 'self.zone_id' };

# has_one
#   price => 'Yetie::Schema::Result::ShippingFeePrice',
#   { 'foreign.shipping_fee_id' => 'self.id' },
#   { cascade_delete    => 0 };

has_many
  prices => 'Yetie::Schema::Result::ShippingFeePrice',
  { 'foreign.shipping_fee_id' => 'self.id' },
  { cascade_delete            => 0 };

# Methods
sub latest_price {
    my $self = shift;
    return $self->prices->search( {}, { order_by => { -desc => 'price_id' } } )->limit(1)->first->price;
}

sub to_data {
    my $self = shift;

    my $data = $self->SUPER::to_data;
    $data->{price} = $self->latest_price->to_data;

    return $data;
}

1;
