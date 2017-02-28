package Markets::Schema::Result::Preference;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column key_name => {
    data_type => 'VARCHAR',
    size      => 50,
};

column value => {
    data_type   => 'TEXT',
    is_nullable => 1,
};

column default_value => {
    data_type   => 'TEXT',
    is_nullable => 0,
};

column summary => {
    data_type   => 'TEXT',
    is_nullable => 1,
};

column position => {
    data_type     => 'INT',
    default_value => 0,
    is_nullable   => 0,
};

column group_id => {
    data_type     => 'INT',
    default_value => 0,
    is_nullable   => 0,
};

1;
