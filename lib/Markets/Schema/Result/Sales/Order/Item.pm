package Markets::Schema::Result::Sales::Order::Item;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column product_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column quantity => {
    data_type   => 'INT',
    is_nullable => 1,
};

belongs_to order => 'Markets::Schema::Result::Sales::Order', 'order_id';

1;
