package Yetie::Schema::Result::Activity;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'BIGINT',
    is_auto_increment => 1,
};

column name => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column action => {
    data_type   => 'VARCHAR',
    size        => 32,
    is_nullable => 0,
};

column status => {
    data_type   => 'ENUM',
    is_nullable => 0,
    extra       => {
        list => [qw/success failure/]
    },
};

column message => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 1,
};

column remote_address => {
    data_type   => 'VARCHAR',
    size        => 45,
    is_nullable => 0,
};

column user_agent => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

# Relation
has_many
  customer_activities => 'Yetie::Schema::Result::Customer::Activity',
  { 'foreign.activity_id' => 'self.id' },
  { cascade_delete        => 0 };

1;
