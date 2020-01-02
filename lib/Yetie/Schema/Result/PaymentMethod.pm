package Yetie::Schema::Result::PaymentMethod;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column name => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

# Relation
has_many
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.payment_method_id' => 'self.id' },
  { cascade_delete              => 0 };

1;
