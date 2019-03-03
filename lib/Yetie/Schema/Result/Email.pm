package Yetie::Schema::Result::Email;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

# NOTE: Column that use index have a max key length is 767 bytes.
column address => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

# Relation
might_have
  customer_email => 'Yetie::Schema::Result::Customer::Email',
  { 'foreign.email_id' => 'self.id' };

# Index
unique_constraint ui_address => [qw/address/];

1;
