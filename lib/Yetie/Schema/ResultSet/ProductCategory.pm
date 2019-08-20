package Yetie::Schema::ResultSet::ProductCategory;
use Mojo::Base 'Yetie::Schema::ResultSet';

sub get_primary_category {
    my $self = shift;

    foreach my $product_category ( $self->all ) {
        next if !$product_category->is_primary;
        return $product_category->category;
    }
    return;
}

sub get_primary_category_id {
    my $self = shift;

    my $primary_category = $self->get_primary_category;
    return $primary_category ? $primary_category->id : undef;
}

1;
__END__
=encoding utf8

=head1 NAME

Yetie::Schema::ResultSet::ProductCategory

=head1 SYNOPSIS

    my $result = $schema->resultset('ProductCategory')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::ProductCategory> inherits all attributes from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::ProductCategory> inherits all methods from L<Yetie::Schema::ResultSet> and implements
the following new ones.

=head2 C<get_primary_category>

    my $result = $rs->search( { product_id => 1 } )->get_primary_category;

Return L<Yetie::Schema::Result::Category> object or C<undef>.

=head2 C<get_primary_category_id>

    my $id = $rs->search( { product_id => 1 } )->get_primary_category_id;

Return Scalar value or C<undef>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::ResultSet>, L<Yetie::Schema>
