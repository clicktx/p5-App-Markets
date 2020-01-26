package Yetie::Schema::Result::SalesOrderItemPrice;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::SalesPrice;
use Yetie::Schema::Result::SalesOrderItem;

primary_column price_id => { data_type => Yetie::Schema::Result::SalesPrice->column_info('id')->{data_type}, };

column item_id => {
    data_type   => Yetie::Schema::Result::SalesOrderItem->column_info('id')->{data_type},
    is_nullable => 0,
};

# Relation
belongs_to
  price => 'Yetie::Schema::Result::SalesPrice',
  { 'foreign.id' => 'self.price_id' };

belongs_to
  item => 'Yetie::Schema::Result::SalesOrderItem',
  { 'foreign.id' => 'self.item_id' };

sub to_data {
    my $self = shift;
    return $self->price->to_data;
}

1;
