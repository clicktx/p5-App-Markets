package Yetie::Schema::Result::StaffPassword;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Staff;
use Yetie::Schema::Result::Password;

primary_column password_id => { data_type => Yetie::Schema::Result::Password->column_info('id')->{data_type} };

column staff_id => {
    data_type   => Yetie::Schema::Result::Staff->column_info('id')->{data_type},
    is_nullable => 0,
};

# Relation
belongs_to
  staff => 'Yetie::Schema::Result::Staff',
  { 'foreign.id' => 'self.staff_id' };

belongs_to
  password => 'Yetie::Schema::Result::Password',
  { 'foreign.id' => 'self.password_id' };

sub to_data {
    my $self = shift;

    return {
        value      => $self->password->hash,
        created_at => $self->password->created_at,
    };
}

1;
