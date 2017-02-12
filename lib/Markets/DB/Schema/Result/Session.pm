package Markets::DB::Schema::Result::Session;
use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column sid => {
    data_type => 'VARCHAR',
    size      => 50,
};

column data => { data_type => 'MEDIUMTEXT', };

column cart_id => {
    data_type   => 'VARCHAR',
    size        => 50,
};

column expires => {
    data_type   => 'BIGINT',
    is_nullable => 1,
};

1;
