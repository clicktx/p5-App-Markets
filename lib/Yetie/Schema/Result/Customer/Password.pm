package Yetie::Schema::Result::Customer::Password;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column customer_id => { data_type => 'INT' };

column password_id => { data_type => 'INT' };

# Relation
belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  password => 'Yetie::Schema::Result::Password',
  { 'foreign.id' => 'self.password_id' };

# Index
sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;

    # alter index type
    my @indices = $table->get_indices;
    foreach my $index (@indices) {
        $index->type('unique') if $index->name eq 'customer_passwords_idx_password_id';
    }
}

sub to_data {
    my $self = shift;

    return {
        value      => $self->password->hash,
        created_at => $self->password->created_at,
        updated_at => $self->password->updated_at,
    };
}

1;
