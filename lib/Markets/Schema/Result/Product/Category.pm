package Markets::Schema::Result::Product::Category;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column product_id  => { data_type => 'INT', };
primary_column category_id => { data_type => 'INT', };

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
