package Yetie::Schema::Result::Password;
use Mojo::Base 'Yetie::Schema::Base::Result';
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

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

# answer question hint create_by_user_id is_active

might_have
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.password_id' => 'self.id' };

# might_have
#   staff => 'Yetie::Schema::Result::Staff',
#   { 'foreign.password_id' => 'self.id' };

1;
