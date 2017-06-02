package Markets::Schema::Result::Session;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column sid => {
    data_type => 'CHAR',
    size      => 40,
};

column data => {
    data_type => 'MEDIUMTEXT',
    is_nullable => 1,
};

column cart_id => {
    data_type => 'VARCHAR',
    size      => 50,
    is_nullable => 0,
};

column expires => {
    data_type   => 'BIGINT',
    is_nullable => 0,
};

# belongs_to
#   'cart' => 'Markets::Schema::Result::Cart',
#   { 'foreign.cart_id' => 'self.cart_id' };

belongs_to cart => 'Markets::Schema::Result::Cart', 'cart_id';

1;
