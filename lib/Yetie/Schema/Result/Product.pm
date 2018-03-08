package Yetie::Schema::Result::Product;
use Mojo::Base 'Yetie::Schema::Base::Result';
use DBIx::Class::Candy -autotable => v1;

primary_column id => {
    data_type         => 'INT',
    is_auto_increment => 1,
};

column title => {
    data_type   => 'VARCHAR',
    size        => 128,
    is_nullable => 0,
};

column description => {
    data_type   => 'TEXT',
    is_nullable => 0,
};

column price => {
    data_type   => 'DECIMAL',
    is_nullable => 0,
    size        => [ 12, 2 ],
};

column created_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

column updated_at => {
    data_type   => 'DATETIME',
    is_nullable => 0,
    timezone    => Yetie::Schema->TZ,
};

# Relation
has_many
  product_categories => 'Yetie::Schema::Result::Product::Category',
  { 'foreign.product_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  order_items => 'Yetie::Schema::Result::Sales::Order::Item',
  { 'foreign.product_id' => 'self.id' },
  { cascade_delete       => 0 };

# Add Index
sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    $sqlt_table->add_index( name => 'idx_title', fields => ['title'] );
}

sub to_data {
    my $self = shift;

    return {
        id                 => $self->id,
        title              => $self->title,
        description        => $self->description,
        price              => $self->price,
        created_at         => $self->created_at,
        updated_at         => $self->updated_at,
        product_categories => $self->product_categories->to_data,
    };
}

1;
