package Yetie::Schema::Result::Sales::Order::Item;
use Mojo::Base 'Yetie::Schema::Base::Result';
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

column product_title => Yetie::Schema::Result::Product->column_info('title');

# column description => {
#     data_type   => 'VARCHAR',
#     size        => 100,
#     is_nullable => 0,
# };

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
};

column price => Yetie::Schema::Result::Product->column_info('price');

# NOTE: 'order' is SQL reserved word.
belongs_to
  sales_order => 'Yetie::Schema::Result::Sales::Order',
  { 'foreign.id' => 'self.order_id' };

belongs_to
  product => 'Yetie::Schema::Result::Product',
  { 'foreign.id' => 'self.product_id' };

sub to_data {
    my $self = shift;

    my @columns = qw(id product_title quantity price);
    my $data    = {};
    $data->{$_} = $self->$_ for @columns;
    return $data;
}

1;
