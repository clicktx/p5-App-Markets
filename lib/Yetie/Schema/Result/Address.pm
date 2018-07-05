package Yetie::Schema::Result::Address;
use Mojo::Base 'Yetie::Schema::Base::Result';
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

column level1 => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
    comments    => 'State/Province/Province/Region',
};

column level2 => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
    comments    => 'City/Town',
};

column postal_code => {
    data_type   => 'VARCHAR',
    size        => 16,
    is_nullable => 0,
    comments    => 'Post Code/Zip Code',
};

column personal_name => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column company_name => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column phone => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column fax => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column mobile => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

# Index
unique_constraint ui_hash => [qw/hash/];

# Relation
has_many
  customer_addresses => 'Yetie::Schema::Result::Customer::Address',
  { 'foreign.address_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  phones => 'Yetie::Schema::Result::Address::Phone',
  { 'foreign.address_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.address_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  orders => 'Yetie::Schema::Result::Sales::Order',
  { 'foreign.address_id' => 'self.id' },
  { cascade_delete       => 0 };

sub to_data {
    my $self = shift;

    my $data = $self->SUPER::to_data || {};
    $data->{phones} = $self->phones->to_data;
    return $data;
}

1;
