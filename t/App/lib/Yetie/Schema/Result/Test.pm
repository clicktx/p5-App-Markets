package Yetie::Schema::Result::Test;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

unique_column name => {
    data_type => 'VARCHAR',
    size      => 50,
};

1;
