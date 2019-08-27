package Yetie::Schema::Result::Session;
use Mojo::Base 'Yetie::Schema::Result';
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
    size      => 40,
    is_nullable => 0,
};

column expires => {
    data_type   => 'INT',
    is_nullable => 0,
};

# Relation
# belongs_to
#   'cart' => 'Yetie::Schema::Result::Cart',
#   { 'foreign.cart_id' => 'self.cart_id' };

belongs_to cart => 'Yetie::Schema::Result::Cart', 'cart_id';

1;
