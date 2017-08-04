package Markets::Schema::Result::Category;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

__PACKAGE__->load_components(qw/Tree::AdjacencyList::Ordered/);
__PACKAGE__->repair_tree(1);

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column parent_id => {
    data_type     => 'INT',
    is_nullable   => 0,
    default_value => 0,
};

column position => {
    data_type   => 'INT',
    is_nullable => 0,
};

column name => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

1;
