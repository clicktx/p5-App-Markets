package Yetie::Schema::Result::SalesOrderItem;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;
use Yetie::Schema::Result::Product;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column tax_rule_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_title => Yetie::Schema::Result::Product->column_info('title');

# column description => {
#     data_type   => 'VARCHAR',
#     size        => 100,
#     is_nullable => 0,
# };

column price => Yetie::Schema::Result::Product->column_info('price');

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
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
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

sub to_data {
    my $self = shift;

    my @columns = qw(id product_id product_title quantity price);
    my $data    = {};
    $data->{$_} = $self->$_ for @columns;

    # relation
    $data->{tax_rule} = $self->tax_rule->to_data;

    return $data;
}

1;
