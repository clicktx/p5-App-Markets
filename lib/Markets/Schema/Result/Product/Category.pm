package Markets::Schema::Result::Product::Category;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column product_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column category_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column is_primary => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

belongs_to
  product => 'Markets::Schema::Result::Product',
  { 'foreign.id' => 'self.product_id' };

belongs_to
  category => 'Markets::Schema::Result::Category',
  { 'foreign.id' => 'self.category_id' };

1;
