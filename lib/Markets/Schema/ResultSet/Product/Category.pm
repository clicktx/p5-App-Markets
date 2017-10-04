package Markets::Schema::ResultSet::Product::Category;
use Mojo::Base 'Markets::Schema::Base::ResultSet';
use Try::Tiny;

sub get_product_categories_arrayref {
    my ( $self, $product_id ) = @_;

    my $itr = $self->search(
        { product_id => $product_id },
        {
            prefetch => 'detail',
            order_by => [ { -desc => [qw(is_primary rgt)] } ],
        },
    );

    my @product_categories;
    while ( my $row = $itr->next ) {
        push @product_categories,
          {
            category_id => $row->category_id,
            is_primary  => $row->is_primary,
            title       => $row->detail->title,
          };
    }
    return \@product_categories;
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Product::Category

=head1 SYNOPSIS

    my $data = $schema->resultset('Product::Category')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::ResultSet::Product::Category> inherits all attributes from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::ResultSet::Product::Category> inherits all methods from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<update_product_categories>

    $resultset->update_product_categories($product_id, \@category_ids, $primary_category_id);

Return L<Markets::Schema::Result::Product> object.

=head2 C<update_product>

    $resultset->update_product( $product_id, \%from_parameters );

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
