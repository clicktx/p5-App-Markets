package Yetie::Schema::Result::Staff;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column login_id => {
    data_type   => 'VARCHAR',
    size        => 64,
    is_nullable => 0,
};

column account_id => {
    data_type   => 'INT',
    is_nullable => 0,
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

# Index
unique_constraint staffs_ui_login_id   => [qw/login_id/];
unique_constraint staffs_ui_account_id => [qw/account_id/];

# Relation
belongs_to
  account => 'Yetie::Schema::Result::Account',
  { 'foreign.id' => 'self.account_id' };

# has_many
#   emails => 'Yetie::Schema::Result::Staff::Email',
#   { 'foreign.customer_id' => 'self.id' };
#
# has_many
#   addresses => 'Yetie::Schema::Result::Staff::Address',
#   { 'foreign.customer_id' => 'self.id' };
#

sub to_data {
    my $self = shift;

    return {
        id         => $self->id,
        login_id   => $self->login_id,
        created_at => $self->created_at,
        updated_at => $self->updated_at,
        account    => $self->account->to_data,
    };
}

1;
