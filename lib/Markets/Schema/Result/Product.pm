package Markets::Schema::Result::Product;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column title => {
    data_type => 'VARCHAR',
    size      => 128,
    is_nullable => 0,
};

column description => {
    data_type   => 'TEXT',
    is_nullable => 0,
};

column price => {
    data_type   => 'DECIMAL',
    is_nullable => 0,
    size        => [ 12, 2 ],
};

1;
