package Yetie::Schema::Result::Addon;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => { data_type => 'INT', };

unique_column name => {
    data_type => 'VARCHAR',
    size      => 50,
};

column is_enabled => {
    data_type     => 'TINYINT',
    size          => 1,
    is_nullable   => 1,
    default_value => 0,
};

has_many
  triggers => 'Yetie::Schema::Result::Addon::Trigger',
  'addon_id',
  { cascade_delete => 1 };

1;
