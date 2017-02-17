package Markets::DB::Schema::Result::Cart;

use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column cart_id => {
    data_type => 'VARCHAR',
    size      => 50,
};

column data => { data_type => 'MEDIUMTEXT', };

has_many session => 'Markets::DB::Schema::Result::Session', 'cart_id';

1;
