package Markets::Schema::Result::Order::Item;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};
primary_column order_id => { data_type => 'INT', };

column description => {
    data_type   => 'VARCHAR',
    size        => 100,
    is_nullable => 0,
};

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
};

belongs_to
  order => 'Markets::Schema::Result::Order',
  { 'foreign.id' => 'self.order_id' };

1;
