package Yetie::Schema::Result::Password;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column hash => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => Yetie::Schema->TZ,
};

# Relation
has_many
  customer => 'Yetie::Schema::Result::Customer::Password',
  { 'foreign.password_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  staff => 'Yetie::Schema::Result::Staff::Password',
  { 'foreign.password_id' => 'self.id' },
  { cascade_delete        => 0 };

# sub to_data {
#     my $self = shift;
#
#     return {
#         id         => $self->id,
#         hash       => $self->hash,
#         created_at => $self->created_at,
#         updated_at => $self->updated_at,
#     };
# }

1;
