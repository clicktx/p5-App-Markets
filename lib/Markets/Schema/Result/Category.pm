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

column title => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

has_many
  products => 'Markets::Schema::Result::Product::Category',
  { 'foreign.category_id' => 'self.id' };

# NOTE: 下記に書いた場合deploy_schema時にテーブル作成に失敗する（relation設定によるもの？）
#       tree_columnsを呼ばないとapplicationで動かないため、App::Commonで読み込む。
# __PACKAGE__->tree_columns(
#     {
#         root_column  => 'root_id',
#         left_column  => 'lft',
#         right_column => 'rgt',
#         level_column => 'level',
#     }
# );

# Add Index
sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    $sqlt_table->add_index( name => 'idx_root_id', fields => ['root_id'] );
    $sqlt_table->add_index( name => 'idx_level',   fields => ['level'] );
}

# search_related with special handling for relationships
# NOTE: 取得するcolumnsを限定できるかとおもいきやancestorsが複数あると2つ目以降は全てのカラムを取得してしまう
# sub search_related {
#     my ( $self, $rel, $cond, @rest ) = @_;
#
#     my $columns = [qw( me.id me.root_id me.level me.title)];
#     push @rest, { 'columns' => $columns };
#     return $self->next::method( $rel, $cond, @rest );
# }
# *search_related_rs = \&search_related;

1;
