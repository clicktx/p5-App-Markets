package Yetie::Schema::Result::Customer;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column account_id => {
    data_type => 'INT',

    # 未登録カスタマーを許容
    is_nullable => 1,
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

# Index
unique_constraint customers_ui_account_id => [qw/account_id/];

# Relation
belongs_to
  account => 'Yetie::Schema::Result::Account',
  { 'foreign.id' => 'self.account_id' };

has_many
  emails => 'Yetie::Schema::Result::Customer::Email',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  addresses => 'Yetie::Schema::Result::Customer::Address',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

1;
