package Yetie::Schema::Result::Address::Phone;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column address_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column phone_type_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column number => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
    comments    => 'For display',
};

# The telephone number specified in E.164 is 15 digits or less excluding the country code.
column number_only => {
    data_type   => 'VARCHAR',
    size        => 16,
    is_nullable => 0,
    comments    => 'Not include hyphen and symbols',
};

# Relation
belongs_to
  address => 'Yetie::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

belongs_to
  type => 'Yetie::Schema::Result::Address::Phone::Type',
  { 'foreign.id' => 'self.phone_type_id' };

# Index
sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    $sqlt_table->add_index( name => 'idx_number', fields => ['number'] );
}

1;
