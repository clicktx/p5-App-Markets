package Yetie::Schema::Result::CustomerActivity;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Customer;
use Yetie::Schema::Result::Activity;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column customer_id => {
    data_type   => Yetie::Schema::Result::Customer->column_info('id')->{data_type},
    is_nullable => 0,
};

column activity_id => {
    data_type   => Yetie::Schema::Result::Activity->column_info('id')->{data_type},
    is_nullable => 0,
    extra       => { unsigned => 1 },
};

# Relation
belongs_to
  customer => 'Yetie::Schema::Result::Customer',
  { 'foreign.id' => 'self.customer_id' };

belongs_to
  activity => 'Yetie::Schema::Result::Activity',
  { 'foreign.id' => 'self.activity_id' };

# Index
sub sqlt_deploy_hook {
    my ( $self, $table ) = @_;

    # alter index type
    my @indices = $table->get_indices;
    foreach my $index (@indices) {
        $index->type('unique') if $index->name eq 'customer_activities_idx_activity_id';
    }
}

1;
