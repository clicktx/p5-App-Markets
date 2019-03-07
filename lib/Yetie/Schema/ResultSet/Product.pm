package Yetie::Schema::ResultSet::Product;
use Mojo::Base 'Yetie::Schema::ResultSet';
use Try::Tiny;

sub find_product {
    my ( $self, $product_id ) = @_;

    return $self->find(
        {
            'me.id' => $product_id
        },
        {
            prefetch => { product_categories => 'detail' },
            order_by => 'lft',
        }
    );
}

sub search_products {
    my ( $self, $conditions ) = @_;

    my $where    = $conditions->{where}    || {};
    my $order_by = $conditions->{order_by} || { -desc => [ 'updated_at', 'created_at' ] };
    my $page     = $conditions->{page_no}  || 1;
    my $rows     = $conditions->{per_page} || 10;

    return $self->search(
        $where,
        {
            order_by => $order_by,
            page     => $page,
            rows     => $rows,
        }
    );
}

sub update_product_categories {
    my ( $self, $product_id, $category_ids, $primary_category_id ) = @_;

    # NOTE: 通常は設定しているプライマリを引き継ぐ
    # 例外: パラメーターの最初のカテゴリをプライマリに設定
    # - 選択項目が1つの場合
    # - 複数指定でも取得したprimary_idが選択項目にない場合
    my $product_categories = [];
    my $has_primary;
    foreach my $category_id ( @{$category_ids} ) {
        my $is_primary = 0;
        if ( $category_id == $primary_category_id ) {
            $is_primary  = 1;
            $has_primary = 1;
        }
        push @{$product_categories},
          {
            category_id => $category_id,
            is_primary  => $is_primary
          };
    }
    $product_categories->[0]->{is_primary} = 1 unless $has_primary;

    my $product = $self->find($product_id);
    my $cb      = sub {
        $product->product_categories->delete;
        $product->product_categories->populate($product_categories);
    };

    try { $self->schema->txn_do($cb) }
    catch { $self->schema->txn_failed($_) };

    return $product;
}

sub update_product {
    my ( $self, $product_id, $form ) = @_;

    my $product = $self->find( $product_id, { prefetch => { product_categories => 'detail' } } );
    my $cb = sub {

        # Primary category
        $product->product_categories->update( { is_primary => 0 } );
        $product->product_categories->search( { category_id => $form->param('primary_category') } )
          ->update( { is_primary => 1 } );

        # Product detail
        $product->update(
            {
                title       => $form->param('title'),
                description => $form->param('description'),
                price       => $form->param('price'),
            }
        );
    };

    try { $self->schema->txn_do($cb) }
    catch { $self->schema->txn_failed($_) };
    return $product;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::Product

=head1 SYNOPSIS

    my $result = $schema->resultset('Product')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Product> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Product> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<find_product>

    my $result = $resultset->find_product($product_id);

Return L<Yetie::Schema::Result::Product> object.

=head2 C<search_products>

    my $products_rs = $resultset->search_products(\%conditions);

Return L<Yetie::Schema::ResultSet::Product> object.

=head2 C<update_product_categories>

    $resultset->update_product_categories($product_id, \@category_ids, $primary_category_id);

Return L<Yetie::Schema::Result::Product> object.

=head2 C<update_product>

    $resultset->update_product( $product_id, \%from_parameters );

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
