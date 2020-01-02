package Yetie::Schema::Result::Product;
use Mojo::Base 'Yetie::Schema::Result';
use DBIx::Class::Candy -autotable => v1;

use Yetie::Schema::Result::Price;

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

column price => Yetie::Schema::Result::Price->column_info('value');

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

# Relation
has_many
  product_categories => 'Yetie::Schema::Result::ProductCategory',
  { 'foreign.product_id' => 'self.id' },
  { cascade_delete       => 0 };

has_many
  order_items => 'Yetie::Schema::Result::SalesOrderItem',
  { 'foreign.product_id' => 'self.id' },
  { cascade_delete       => 0 };

# Add Index
sub sqlt_deploy_hook {
    my ( $self, $sqlt_table ) = @_;

    $sqlt_table->add_index( name => 'idx_title', fields => ['title'] );
}

# Methods
sub to_data {
    my ( $self, $options ) = @_;

    my $data = {
        id          => $self->id,
        title       => $self->title,
        description => $self->description,

        # FIXME: There are multiple prices!
        price => {
            value           => $self->price,
            currency_code   => $self->app->pref('locale_currency_code'),
            is_tax_included => $self->app->pref('is_price_including_tax'),
        },
    };

    # Options
    if ( !$options->{no_datetime} ) {
        $data->{created_at} = $self->created_at;
        $data->{updated_at} = $self->updated_at;
    }
    if ( !$options->{no_relation} ) {
        $data->{product_categories} = $self->product_categories->to_data;
    }
    return $data;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::Result::Product

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::Result::Product> inherits all attributes from L<Yetie::Schema::Result> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::Result::Product> inherits all methods from L<Yetie::Schema::Result> and implements
the following new ones.

=head2 C<to_data>

    {
        id                 => '',
        title              => '',
        description        => '',
        price              => '',
        created_at         => DateTime,
        updated_at         => DateTime,
        product_categories => [],
        breadcrumbs        => [],
    }

Return C<Hash reference>.

I<OPTIONS>

    my $data = $result->to_data(
        {
            no_datetime      => 1,
            no_relation      => 1,
        }
    );

=over

=item * no_datetime

Data does not include C<created_at> and C<updated_at>.

=item * no_relation

Data does not include C<product_categories>

=back

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Result>, L<Yetie::Schema>
