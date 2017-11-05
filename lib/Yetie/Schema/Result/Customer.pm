package Yetie::Schema::Result::Customer;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column password_id => {
    data_type => 'INT',

    # 登録者以外の購入者（ビジター購入）もcustomre登録される？
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

belongs_to
  password => 'Yetie::Schema::Result::Password',
  { 'foreign.id' => 'self.password_id' };

has_many
  emails => 'Yetie::Schema::Result::Customer::Email',
  { 'foreign.customer_id' => 'self.id' };

has_many
  addresses => 'Yetie::Schema::Result::Customer::Address',
  { 'foreign.customer_id' => 'self.id' };

has_many
  order_headers => 'Yetie::Schema::Result::Sales::OrderHeader',
  { 'foreign.customer_id' => 'self.id' };

1;
