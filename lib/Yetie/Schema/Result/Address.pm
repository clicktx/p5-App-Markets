package Yetie::Schema::Result::Address;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::AddressCountry;
use Yetie::Schema::Result::AddressState;

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

    %{ Yetie::Schema::Result::AddressCountry->column_info('code') },
    is_nullable => 0,
};

column state_id => {

    data_type   => Yetie::Schema::Result::AddressState->column_info('id')->{data_type},
    is_nullable => 0,
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
belongs_to
  country => 'Yetie::Schema::Result::AddressCountry',
  { 'foreign.code' => 'self.country_code' };

belongs_to
  state => 'Yetie::Schema::Result::AddressState',
  { 'foreign.id' => 'self.state_id' };

has_many
  customer_addresses => 'Yetie::Schema::Result::CustomerAddress',
  { 'foreign.address_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.billing_address_id' => 'self.id' },
  { cascade_delete               => 0 };

has_many
  sales_orders => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.shipping_address_id' => 'self.id' },
  { cascade_delete                => 0 };

1;
