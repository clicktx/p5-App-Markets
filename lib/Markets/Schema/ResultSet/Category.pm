package Markets::Schema::ResultSet::Category;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub get_ancestors_arrayref {
    my ( $self, $category_id ) = @_;

    my @ancestors = $self->find($category_id)->ancestors->hashref_array;
    return \@ancestors;
}

sub get_category_choices {
    my ( $self, $ids ) = ( shift, shift || [] );
    $ids = [$ids] unless ref $ids;

    my @trees;
    my @root_nodes = $self->search( { level => 0 } );
    foreach my $root (@root_nodes) {
        push @trees, @{ _tree( $root, $ids ) };
    }
    return \@trees;
}

sub _tree {
    my ( $root, $ids ) = @_;

    my @tree;
    my $itr = $root->nodes;
    while ( my $node = $itr->next ) {
        my $title = '¦   ' x $node->level . $node->title;
        push @tree, [ $title, $node->id, _choiced( $node->id, $ids ) ];
    }
    return \@tree;
}

sub _choiced {
    my ( $id, $ids ) = @_;

    foreach my $v ( @{$ids} ) {
        return ( choiced => 1 ) if $v == $id;
    }
    return;
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Category

=head1 SYNOPSIS

    my $data = $schema->resultset('Category')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Schema::ResultSet::Category> inherits all attributes from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Markets::Schema::ResultSet::Category> inherits all methods from L<Markets::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<get_ancestors_arrayref>

    my $array_ref = $rs->get_ancestors_arrayref($category_id);

Return Array refference.

=head2 C<get_category_choices>

    my $tree = $rs->get_category_choices();

    # Arguments choiced category ids
    my $tree = $rs->get_category_choices(3);
    my $tree = $rs->get_category_choices( [ 1, 3, 5 ] );

Return Array refference.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
