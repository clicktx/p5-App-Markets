package Yetie::Schema::Result::Account;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
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
has_one
  password => 'Yetie::Schema::Result::Password',
  { 'foreign.account_id' => 'self.id' },
  { cascade_delete       => 0 };

might_have
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.account_id' => 'self.id' },
  { cascade_delete       => 0 };

has_one
  staff => 'Yetie::Schema::Result::Staff',
  { 'foreign.account_id' => 'self.id' },
  { cascade_delete       => 0 };

1;
