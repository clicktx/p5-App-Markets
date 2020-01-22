package Yetie::Schema::Result::ShippingCarrier;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

# description, website, tracking-confirm-url,
# Detail table create?
column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

# Relation
has_many
  services => 'Yetie::Schema::Result::ShippingCarrierService',
  { 'foreign.carrier_id' => 'self.id' },
  { cascade_delete       => 0 };

1;
