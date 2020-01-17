package Yetie::Schema::Result::SalesOrderItemPrice;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::SalesOrderItem;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column item_id => {
    data_type   => Yetie::Schema::Result::SalesOrderItem->column_info('id')->{data_type},
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
  item => 'Yetie::Schema::Result::SalesOrderItem',
  { 'foreign.id' => 'self.item_id' };

# Methods
sub to_data {
    my $self = shift;

    my $data    = {};
    my @columns = qw(value currency_code is_tax_included);
    $data->{$_} = $self->$_ for @columns;

    return $data;
}

1;
