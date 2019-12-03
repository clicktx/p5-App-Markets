package Yetie::Schema::Result::ProductCategory;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Product;
use Yetie::Schema::Result::Category;

primary_column product_id  => { data_type => Yetie::Schema::Result::Product->column_info('id')->{data_type} };
primary_column category_id => { data_type => Yetie::Schema::Result::Category->column_info('id')->{data_type} };

column is_primary => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

# Relation
belongs_to
  product => 'Yetie::Schema::Result::Product',
  { 'foreign.id' => 'self.product_id' };

belongs_to
  category => 'Yetie::Schema::Result::Category',
  { 'foreign.id' => 'self.category_id' };

sub to_data {
    my $self = shift;

    return {
        category_id => $self->category_id,
        is_primary  => $self->is_primary,
        title       => $self->category->title,
    };
}

1;
