package Markets::Schema::Result::Password;
use Mojo::Base 'Markets::Schema::ResultCommon';
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
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Markets::Schema->TZ,
};

# answer question hint create_by_user_id is_active

might_have
  customer => 'Markets::Schema::Result::Customer',
  { 'foreign.password_id' => 'self.id' };

# might_have
#   staff => 'Markets::Schema::Result::Staff',
#   { 'foreign.password_id' => 'self.id' };

1;
