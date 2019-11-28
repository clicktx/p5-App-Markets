package Yetie::Schema::Result::StaffPassword;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Staff;
use Yetie::Schema::Result::Password;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column staff_id => {
    data_type   => Yetie::Schema::Result::Staff->column_info('id')->{data_type},
    is_nullable => 0,
};

column password_id => {
    data_type   => Yetie::Schema::Result::Password->column_info('id')->{data_type},
    is_nullable => 0,
};

# Relation
belongs_to
  staff => 'Yetie::Schema::Result::Staff',
  { 'foreign.id' => 'self.staff_id' };

belongs_to
  password => 'Yetie::Schema::Result::Password',
  { 'foreign.id' => 'self.password_id' };

# Index
sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;

    # alter index type
    my @indices = $table->get_indices;
    foreach my $index (@indices) {
        $index->type('unique') if $index->name eq 'staff_passwords_idx_password_id';
    }
}

sub to_data {
    my $self = shift;

    return {
        value      => $self->password->hash,
        created_at => $self->password->created_at,
    };
}

1;
