package Yetie::Schema::Result::Address::Phone::Type;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column name => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

has_many
  phones => 'Yetie::Schema::Result::Address::Phone',
  { 'foreign.phone_type_id' => 'self.id' },
  { cascade_delete          => 0 };

1;
