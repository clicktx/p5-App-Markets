package Yetie::Schema::Result::Customer;
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
might_have
  password => 'Yetie::Schema::Result::Customer::Password',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

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
