package Yetie::Schema::Result::Customer;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => __PACKAGE__->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => __PACKAGE__->TZ,
};

column last_logged_in_at => {
    data_type   => 'DATETIME',
    is_nullable => 1,
    timezone    => __PACKAGE__->TZ,
};

# Relation
might_have
  customer_password => 'Yetie::Schema::Result::CustomerPassword',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  emails => 'Yetie::Schema::Result::CustomerEmail',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  addresses => 'Yetie::Schema::Result::CustomerAddress',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  sales => 'Yetie::Schema::Result::Sales',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

has_many
  activities => 'Yetie::Schema::Result::CustomerActivity',
  { 'foreign.customer_id' => 'self.id' },
  { cascade_delete        => 0 };

sub to_data {
    my $self = shift;

    return {
        id         => $self->id,
        created_at => $self->created_at,
        updated_at => $self->updated_at,
        password   => $self->customer_password ? $self->customer_password->to_data : '',
        emails     => $self->emails->to_data,
    };
}

1;
