package Yetie::Schema::Result::Preference;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

unique_column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

column value => {
    data_type   => 'TEXT',
    is_nullable => 1,
};

column default_value => {
    data_type   => 'TEXT',
    is_nullable => 0,
};

column title => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 1,
};

column summary => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 1,
};

column position => {
    data_type     => 'INT',
    default_value => 100,
    is_nullable   => 0,
};

column group_id => {
    data_type     => 'INT',
    default_value => 1,
    is_nullable   => 0,
};

1;
