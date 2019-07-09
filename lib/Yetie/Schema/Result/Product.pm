package Yetie::Schema::Result::Product;
use Mojo::Base 'Yetie::Schema::Result';
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
    is_nullable => 1,
    timezone    => Yetie::Schema->TZ,
};

# Relation
has_many
  tax_rules => 'Yetie::Schema::Result::ProductTaxRule',
  { 'foreign.product_id' => 'self.id' },
  { cascade_delete       => 0 };

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
sub find_primary_category {
    my $self = shift;

    my $rs = $self->product_categories->search( { is_primary => 1 } );
    my $primary_category = $self->schema->resultset('Category')->find(
        {
            id => { '=' => $rs->get_column('category_id')->as_query }
        }
    );
}

sub find_tax_rule {
    my ( $self, $dt ) = @_;

    my $where = {
        -or => [
            -and => [
                start_at => { '<=' => $dt },
                end_at   => { '>=' => $dt },
            ],
            -and => [
                start_at => { '<=' => $dt },
                end_at   => { 'is' => undef },
            ],
        ]
    };

    # product tax rule
    my $product_tax_rules = $self->tax_rules->search($where);
    return $product_tax_rules->first->tax_rule if $product_tax_rules->first;

    # category tax rule
    my $primary_category = $self->product_categories->get_primary_category;
    return if !$primary_category;

    my $category_tax_rules = $self->schema->resultset('CategoryTaxRule')->search(
        {
            -and => [
                $where,
                {
                    -and => [
                        root_id => $primary_category->root_id,
                        lft     => { '<=' => $primary_category->lft },
                        rgt     => { '>=' => $primary_category->rgt },
                    ]
                },
            ],
        },
        {
            prefetch => [qw/category tax_rule/],
            order_by => { '-DESC' => 'level' },
        }
    );
    my $category_tax_rule = $category_tax_rules->first;
    return $category_tax_rule ? $category_tax_rule->tax_rule : undef;
}

sub find_tax_rule_now {
    my $self = shift;

    my $now = $self->schema->app->date_time->now;
    return $self->find_tax_rule($now);
}

sub to_data {
    my ( $self, $options ) = @_;

    my $data = {
        id          => $self->id,
        title       => $self->title,
        description => $self->description,
        price       => $self->price,
    };

    # Options
    if ( !$options->{no_datetime} ) {
        $data->{created_at} = $self->created_at;
        $data->{updated_at} = $self->updated_at;
    }
    if ( !$options->{no_relation} ) {
        $data->{product_categories} = $self->product_categories->to_data;
    }
    if ( !$options->{no_breadcrumbs} ) {
        $data->{breadcrumbs} = $self->find_primary_category->to_breadcrumbs;
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

=head2 C<find_primary_category>

    $primary_category = $result->find_primary_category;

Returns L<Yetie::Schema::Result::Category> object.

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
            no_breadcrumbs   => 1,
        }
    );

=over

=item * no_datetime

Data does not include C<created_at> and C<updated_at>.

=item * no_relation

Data does not include C<product_categories>

=item * no_breadcrumbs

Data does not include C<breadcrumbs>.

=back

=head2 C<find_tax_rule>

    my $tax_rule = $result->find_tax_rule($DateTimeObject);

Return L<Yetie::Schema::Result::TaxRule> object or C<undef>.

=head2 C<find_tax_rule_now>

    my $tax_rule = $result->find_tax_rule_now;

    # Longer version
    my $tax_rule = $result->find_tax_rule( DateTime->now(...) );

See L</find_tax_rule>

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Result>, L<Yetie::Schema>
