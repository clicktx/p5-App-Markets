package Yetie::Schema::Result::SalesOrderItem;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;
use Yetie::Schema::Result::Product;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column order_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column tax_rule_id => {
    data_type   => 'INT',
    is_nullable => 0,
};

column product_title => Yetie::Schema::Result::Product->column_info('title');

column quantity => {
    data_type   => 'INT',
    is_nullable => 0,
};

column price => Yetie::Schema::Result::Product->column_info('price');

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

column note => {
    data_type   => 'VARCHAR',
    size        => 255,
    is_nullable => 1,
};

# NOTE: deflate data at insert
inflate_column price => {
    inflate => sub { shift },
    deflate => sub {
        my ( $data_from_app, $result ) = @_;
        $result->currency_code( $data_from_app->{currency_code} );
        $result->is_tax_included( $data_from_app->{is_tax_included} );
        return $data_from_app->{value};
    },
};

# Relation
# NOTE: 'order' is SQL reserved word.
belongs_to
  sales_order => 'Yetie::Schema::Result::SalesOrder',
  { 'foreign.id' => 'self.order_id' };

belongs_to
  product => 'Yetie::Schema::Result::Product',
  { 'foreign.id' => 'self.product_id' };

belongs_to
  tax_rule => 'Yetie::Schema::Result::TaxRule',
  { 'foreign.id' => 'self.tax_rule_id' };

# Methods
sub to_data {
    my $self = shift;

    my @columns = qw(id product_id product_title quantity note);
    my $data    = {};
    $data->{$_} = $self->$_ for @columns;

    # price
    $data->{price} = {
        value           => $self->price,
        currency_code   => $self->currency_code,
        is_tax_included => $self->is_tax_included,
    };

    # relation
    $data->{tax_rule} = $self->tax_rule->to_data;

    return $data;
}

1;
