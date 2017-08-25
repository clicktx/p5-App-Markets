package Markets::Schema::ResultSet::Product;
use Mojo::Base 'Markets::Schema::Base::ResultSet';
use Try::Tiny;

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

    try { $self->result_source->schema->txn_do($cb) }
    catch { $self->result_source->schema->txn_failed($_) };

    return $product;
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Product

=head1 SYNOPSIS

    my $data = $schema->resultset('Product')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::ResultSet::Product> inherits all attributes from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::ResultSet::Product> inherits all methods from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<update_product_categories>

    $schema->update_product_categories($product_id, \@category_ids, $primary_category_id);

Return L<Markets::Schema::Result::Product> object.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
