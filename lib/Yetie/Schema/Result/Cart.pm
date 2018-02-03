package Yetie::Schema::Result::Cart;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column cart_id => {
    data_type => 'CHAR',
    size      => 40,
};

column data => {
    data_type   => 'MEDIUMTEXT',
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

has_many
  session => 'Yetie::Schema::Result::Session',
  'cart_id',
  { cascade_delete => 1 };

1;
