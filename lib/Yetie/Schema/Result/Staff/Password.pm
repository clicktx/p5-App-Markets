package Yetie::Schema::Result::Staff::Password;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column staff_id => { data_type => 'INT' };

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

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

# Relation
belongs_to
  staff => 'Yetie::Schema::Result::Staff',
  { 'foreign.id' => 'self.staff_id' };

1;
