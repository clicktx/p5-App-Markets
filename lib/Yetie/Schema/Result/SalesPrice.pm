package Yetie::Schema::Result::SalesPrice;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::TaxRule;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column tax_rule_id => {
    data_type   => 'INT',
    data_type   => Yetie::Schema::Result::TaxRule->column_info('id')->{data_type},
    is_nullable => 0,
};

column value => {
    data_type   => 'DECIMAL',
    is_nullable => 0,
    size        => [ 12, 4 ],
};

column currency_code => {
    data_type   => 'VARCHAR',
    size        => 3,
    is_nullable => 0,
};

column is_tax_included => {
    data_type     => 'BOOLEAN',
    is_nullable   => 0,
    default_value => 0,
};

# NOTE: deflate data at insert
inflate_column value => {
    inflate => sub { shift },
    deflate => sub {
        my ( $data_from_app, $result ) = @_;
        $result->currency_code( $data_from_app->{currency_code} );
        $result->is_tax_included( $data_from_app->{is_tax_included} );
        return $data_from_app->{value};
    },
};

# Relation
belongs_to
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

might_have
  order_item => 'Yetie::Schema::Result::SalesOrderItem',
  { 'foreign.price_id' => 'self.id' },
  { cascade_delete     => 0 };

# Methods
sub to_data {
    my $self = shift;

    my $data    = {};
    my @columns = qw(value currency_code is_tax_included);
    $data->{$_} = $self->$_ for @columns;

    # relation
    $data->{tax_rule} = $self->tax_rule->to_data;

    return $data;
}

1;
