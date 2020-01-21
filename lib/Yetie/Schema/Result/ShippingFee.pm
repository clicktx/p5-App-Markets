package Yetie::Schema::Result::ShippingFee;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

# column created_at => {
#     data_type   => 'DATETIME',
#     is_nullable => 0,
#     timezone    => Yetie::Schema->TZ,
# };

# column updated_at => {
#     data_type   => 'DATETIME',
#     is_nullable => 1,
#     timezone    => Yetie::Schema->TZ,
# };

# Relation
has_many
  prices => 'Yetie::Schema::Result::ShippingFeePrice',
  { 'foreign.shipping_fee_id' => 'self.id' },
  { cascade_delete            => 0 };

# Methods
sub price {
    my $self = shift;
    return $self->prices->first->price;
}

sub to_data {
    my $self = shift;

    my $data = $self->SUPER::to_data;
    $data->{price} = $self->price->to_data;

    return $data;
}

1;
