package Markets::DB2::Schema::Result::Preference;
use strict;
use warnings;

use DBIx::Class::Candy -autotable => v1;

primary_column key_name => {
    data_type => 'VARCHAR',
    size      => 50,
};

column value => { data_type => 'TEXT', };

column default_value => {
    data_type   => 'TEXT',
    is_nullable => 1,
};

column summary => { data_type => 'TEXT', };

column label => { data_type => 'INT', };

column position => {
    data_type     => 'INT',
    default_value => 0,
};

1;
