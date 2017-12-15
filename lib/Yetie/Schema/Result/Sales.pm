package Yetie::Schema::Result::Sales;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => 'singular';

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

1;
