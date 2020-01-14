package Yetie::Schema::Result::Shipment;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::SalesOrder;
use Yetie::Schema::Result::SalesPrice;
use Yetie::Schema::Result::TaxRule;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => Yetie::Schema::Result::SalesOrder->column_info('id')->{data_type},
    is_nullable => 0,
};

# column shipping_address_id => {
#     data_type   => 'INT',
#     is_nullable => 0,
# };

# Unique column
column price_id => {
    data_type   => Yetie::Schema::Result::SalesPrice->column_info('id')->{data_type},
    is_nullable => 0,
};

column tax_rule_id => {
    data_type   => 'INT',
    data_type   => Yetie::Schema::Result::TaxRule->column_info('id')->{data_type},
    is_nullable => 0,
};

column tracking_number => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 1,
};

column completed_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Yetie::Schema->TZ,
};

# Relation
belongs_to
  price => 'Yetie::Schema::Result::SalesPrice',
  { 'foreign.id' => 'self.price_id' };

belongs_to
  sales_order => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.id' => 'self.order_id' };

belongs_to
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

has_many
  shipment_items => 'Yetie::Schema::Result::ShipmentItem',
  { 'foreign.shipment_id' => 'self.id' },
  { cascade_delete        => 0 };

# Index
sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;

    # alter index type
    my @indices = $table->get_indices;
    foreach my $index (@indices) {
        $index->type('unique') if $index->name eq 'shipments_idx_price_id';
    }
}

1;
