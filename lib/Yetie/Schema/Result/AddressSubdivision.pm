package Yetie::Schema::Result::AddressSubdivision;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column code => {
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

# Relation
has_many
  shipping_zones => 'Yetie::Schema::Result::ShippingCarrierServiceZoneSubdivision',
  { 'foreign.subdivision_code' => 'self.code' },
  { cascade_delete             => 0 };

1;
