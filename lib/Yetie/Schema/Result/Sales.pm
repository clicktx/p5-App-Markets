package Yetie::Schema::Result::Sales;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => 'singular';

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column customer_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column billing_address_id => {
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
    is_nullable => 1,
    timezone    => Yetie::Schema->TZ,
};

belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  billing_address => 'Yetie::Schema::Result::Address',
  { 'foreign.id' => 'self.billing_address_id' };

has_many
  orders => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.sales_id' => 'self.id' },
  { cascade_delete     => 0 };

sub is_multiple_shipping { shift->orders->count > 1 ? 1 : 0 }

1;
__END__

=encoding utf8

=head1 METHODS

L<Yetie::Schema::Result::Sales> inherits all methods from L<Yetie::Schema::Result> and implements
the following new ones.

=head2 C<is_multiple_shipping>

    my $bool = $result->is_multiple_shipping;

Return boolean value.

=cut
