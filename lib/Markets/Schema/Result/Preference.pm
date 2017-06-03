package Markets::Schema::Result::Preference;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column key_name => {
    data_type => 'VARCHAR',
    size      => 32,
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
    # is_nullable   => 0,
    is_nullable   => 1,
};

column group_id => {
    data_type     => 'INT',
    default_value => 0,
    # is_nullable   => 0,
    is_nullable   => 1,
};

unique_constraint ui_key_name => [qw/key_name/];

1;
