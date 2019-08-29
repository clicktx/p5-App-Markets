package Yetie::Schema::Result::Addon;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => { data_type => 'INT', };

unique_column name => {
    data_type => 'VARCHAR',
    size      => 64,
};

column is_enabled => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

# Relation
has_many
  triggers => 'Yetie::Schema::Result::AddonTrigger',
  { 'foreign.addon_id' => 'self.id' },
  { cascade_delete     => 0 };

1;
