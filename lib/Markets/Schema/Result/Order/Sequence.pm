package Markets::Schema::Result::Order::Sequence;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
};

1;
