package Yetie::Schema::Result::Password;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column hash => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

# Relation
might_have
  customer => 'Yetie::Schema::Result::CustomerPassword',
  { 'foreign.password_id' => 'self.id' },
  { cascade_delete        => 0 };

might_have
  staff => 'Yetie::Schema::Result::StaffPassword',
  { 'foreign.password_id' => 'self.id' },
  { cascade_delete        => 0 };

1;
