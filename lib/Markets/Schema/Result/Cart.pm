package Markets::Schema::Result::Cart;
use Mojo::Base 'Markets::Schema::ResultCommon';
use DBIx::Class::Candy -autotable => v1;

primary_column cart_id => {
    data_type => 'VARCHAR',
    size      => 50,
};

column data => {
    data_type   => 'MEDIUMTEXT',
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

has_many session => 'Markets::Schema::Result::Session', 'cart_id';

1;
