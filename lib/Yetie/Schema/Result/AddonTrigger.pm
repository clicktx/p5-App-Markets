package Yetie::Schema::Result::AddonTrigger;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Addon;

primary_column id => { data_type => 'INT', };

column addon_id => {
    data_type   => Yetie::Schema::Result::Addon->column_info('id')->{data_type},
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

# Relation
belongs_to
  staff => 'Yetie::Schema::Result::Addon',
  { 'foreign.id' => 'self.addon_id' };

1;
