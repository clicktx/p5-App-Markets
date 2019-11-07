package Yetie::Schema::Result::Address;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column hash => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

column country_code => {
    data_type   => 'VARCHAR',
    size        => 2,
    is_nullable => 0,
    comments    => 'ISO 3166-1 alpha-2',
};

column line1 => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

column line2 => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

column city => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
    comments    => 'City/Town',
};

column state => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
    comments    => 'State/Province/Province/Region',
};

column postal_code => {
    data_type   => 'VARCHAR',
    size        => 16,
    is_nullable => 0,
    comments    => 'Post Code/Zip Code',
};

column organization => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column personal_name => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column phone => {
    data_type   => 'VARCHAR',
    size        => 16,
    is_nullable => 0,
    comments    => 'Not include hyphen and symbols',
};

# Index
unique_constraint ui_hash => [qw/hash/];

sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;
    $table->add_index( name => 'idx_phone', fields => ['phone'] );
}

# Relation
has_many
  customer_addresses => 'Yetie::Schema::Result::CustomerAddress',
  { 'foreign.address_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.billing_address_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  sales_orders => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.shipping_address_id' => 'self.id' },
  { cascade_delete       => 0 };

1;
