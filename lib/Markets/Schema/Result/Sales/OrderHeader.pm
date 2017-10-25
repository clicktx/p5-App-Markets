package Markets::Schema::Result::Sales::OrderHeader;
use Mojo::Base 'Markets::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column customer_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column address_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Markets::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Markets::Schema->TZ,
};

belongs_to
  customer => 'Markets::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  billing_address => 'Markets::Schema::Result::Address',
  { 'foreign.id' => 'self.address_id' };

has_many
  shipments => 'Markets::Schema::Result::Sales::Order::Shipment',
  { 'foreign.order_header_id' => 'self.id' };

=encoding utf8

=head1 METHODS

L<Markets::Schema::Result::Sales::OrderHeader> inherits all methods from L<Markets::Schema::Base::Result> and implements
the following new ones.

=head2 C<is_multiple_shipment>

    my $bool = $result->is_multiple_shipment;

Return boolean value.

=cut

sub is_multiple_shipment { shift->shipments->count > 1 ? 1 : 0 }

1;
