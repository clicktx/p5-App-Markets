package Markets::Schema::Result::Cart;

use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column cart_id => {
    data_type => 'VARCHAR',
    size      => 50,
};

column data => {
    data_type   => 'MEDIUMTEXT',
    is_nullable => 0,
};

has_many session => 'Markets::Schema::Result::Session', 'cart_id';

1;
