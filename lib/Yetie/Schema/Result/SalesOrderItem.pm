package Yetie::Schema::Result::SalesOrderItem;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Product;
use Yetie::Schema::Result::SalesOrder;
use Yetie::Schema::Result::TaxRule;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => Yetie::Schema::Result::SalesOrder->column_info('id')->{data_type},
    is_nullable => 0,
};

column product_id => {
    data_type   => Yetie::Schema::Result::Product->column_info('id')->{data_type},
    is_nullable => 0,
};

column tax_rule_id => {
    data_type   => Yetie::Schema::Result::TaxRule->column_info('id')->{data_type},
    is_nullable => 0,
};

column product_title => Yetie::Schema::Result::Product->column_info('title');

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
};

column note => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 1,
};

# Relation
belongs_to
  product => 'Yetie::Schema::Result::Product',
  { 'foreign.id' => 'self.product_id' };

belongs_to
  sales_order => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.id' => 'self.order_id' };

belongs_to
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

has_one
  price => 'Yetie::Schema::Result::SalesOrderItemPrice',
  { 'foreign.item_id' => 'self.id' },
  { cascade_delete    => 0 };

has_many
  prices => 'Yetie::Schema::Result::SalesOrderItemPrice',
  { 'foreign.item_id' => 'self.id' },
  { cascade_delete    => 0 };

has_many
  shipment_items => 'Yetie::Schema::Result::ShipmentItem',
  { 'foreign.shipment_id' => 'self.id' },
  { cascade_delete        => 0 };

# Methods
sub to_data {
    my $self = shift;

    my $data    = {};
    my @columns = qw(id product_id product_title quantity note);
    $data->{$_} = $self->$_ for @columns;

    # relation
    $data->{price}    = $self->price->to_data;
    $data->{tax_rule} = $self->tax_rule->to_data;

    return $data;
}

1;
