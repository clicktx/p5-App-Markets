package Yetie::Schema::Result::SalesOrderItem;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::SalesOrder;
use Yetie::Schema::Result::Product;
use Yetie::Schema::Result::Price;

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

column price_id => {
    data_type   => Yetie::Schema::Result::Price->column_info('id')->{data_type},
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
# NOTE: 'order' is SQL reserved word.
belongs_to
  sales_order => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.id' => 'self.order_id' };

belongs_to
  product => 'Yetie::Schema::Result::Product',
  { 'foreign.id' => 'self.product_id' };

belongs_to
  price => 'Yetie::Schema::Result::Price',
  { 'foreign.id' => 'self.price_id' };

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

    # price
    $data->{price} = $self->price->to_data;

    # relation
    $data->{tax_rule} = delete $data->{price}->{tax_rule};

    return $data;
}

1;
