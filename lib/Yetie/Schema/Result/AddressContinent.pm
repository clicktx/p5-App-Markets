package Yetie::Schema::Result::AddressContinent;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy
  -autotable  => v1,
  -components => [qw(Ordered)];

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

column position => {
    data_type     => 'INT',
    default_value => 100,
    is_nullable   => 0,
};

# Relation
has_many
  countries => 'Yetie::Schema::Result::AddressCountry',
  { 'foreign.group_id' => 'self.id' },
  { cascade_delete     => 0 };

1;
