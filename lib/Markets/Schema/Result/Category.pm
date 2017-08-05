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

# __PACKAGE__->position_column('position');
# __PACKAGE__->grouping_column('parent_id');

# belongs_to '_parent' => 'Markets::Schema::Result::Category' => { "foreign.id"        => "self.parent_id" };
# has_many 'children'  => 'Markets::Schema::Result::Category' => { "foreign.parent_id" => "self.id" };
# has_many 'parents'   => 'Markets::Schema::Result::Category' => { "foreign.id"        => "self.parent_id" },
#   { cascade_delete => 0, cascade_copy => 0 };
# __PACKAGE__->_parent_column('parent_id');

# __PACKAGE__->relationship_info('children')->{attrs}->{order_by} = 'position';
1;
