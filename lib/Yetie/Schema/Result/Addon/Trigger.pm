package Yetie::Schema::Result::Addon::Trigger;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => { data_type => 'INT', };

column addon_id => {
    data_type   => 'INT',
    is_nullable => 1,
};

column trigger_name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 1,
};

column priority => {
    data_type     => 'INT',
    is_nullable   => 1,
    default_value => 100,
};

belongs_to addon => 'Yetie::Schema::Result::Addon', 'addon_id';

1;
