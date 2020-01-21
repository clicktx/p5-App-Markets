package Yetie::Schema::Result::ShippingFeePrice;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::ShippingFee;
use Yetie::Schema::Result::Price;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column shipping_fee_id => {
    data_type   => Yetie::Schema::Result::ShippingFee->column_info('id')->{data_type},
    is_nullable => 0,
};

column price_id => {
    data_type   => Yetie::Schema::Result::Price->column_info('id')->{data_type},
    is_nullable => 0,
};

# Relation
belongs_to
  shipping_fee => 'Yetie::Schema::Result::ShippingFee',
  { 'foreign.id' => 'self.shipping_fee_id' };

belongs_to
  price => 'Yetie::Schema::Result::Price',
  { 'foreign.id' => 'self.price_id' };

# Index
# sub sqlt_deploy_hook {
#     my ( $self, $table ) = @_;

#     # alter index type
#     my @indices = $table->get_indices;
#     foreach my $index (@indices) {
#         $index->type('unique') if $index->name eq 'staff_passwords_idx_password_id';
#     }
# }

1;
