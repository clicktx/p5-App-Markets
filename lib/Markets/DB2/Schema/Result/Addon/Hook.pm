package Markets::DB2::Schema::Result::Addon::Hook;
use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column id => { data_type => 'INT', };

column addon_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column hook_name => {
    data_type   => 'VARCHAR',
    size        => 50,
    is_nullable => 1,
};

column priority => {
    data_type     => 'INT',
    is_nullable   => 1,
    default_value => 100,
};

belongs_to addon => 'Markets::DB2::Schema::Result::Addon', 'addon_id';

1;
