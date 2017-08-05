package Markets::Schema::Result::Category;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

__PACKAGE__->load_components(qw( Tree::NestedSet ));

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column root_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column lft => {
    data_type   => 'INT',
    is_nullable => 0,
};

column rgt => {
    data_type   => 'INT',
    is_nullable => 0,
};

column level => {
    data_type   => 'INT',
    is_nullable => 0,
};

column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

__PACKAGE__->tree_columns(
    {
        root_column  => 'root_id',
        left_column  => 'lft',
        right_column => 'rgt',
        level_column => 'level',
    }
);

1;
