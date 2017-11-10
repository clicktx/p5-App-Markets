package Yetie::Schema::ResultSet::Category;
use Mojo::Base 'Yetie::Schema::Base::ResultSet';

sub create_category {
    my ( $self, $title, $parent_id ) = @_;
    return unless $title;

    my $result;
    if ($parent_id) {

        # Create child node
        my $parent = $self->find($parent_id) || return;
        $result = $parent->add_to_children( { title => $title } );
    }
    else {
        # Create root node
        $result = $self->create( { title => $title } );
    }

    return $result;
}

sub get_ancestors_arrayref {
    my ( $self, $category_id ) = @_;

    my $result = $self->find($category_id);
    my $ancestors = $result ? $result->ancestors->hashref_array : [];
    return $ancestors;
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

Yetie::Schema::ResultSet::Category

=head1 SYNOPSIS

    my $data = $schema->resultset('Category')->method();

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Schema::ResultSet::Category> inherits all attributes from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head1 METHODS

L<Yetie::Schema::ResultSet::Category> inherits all methods from L<Yetie::Schema::Base::ResultSet> and implements
the following new ones.

=head2 C<create_category>

    # Create root category
    $rs->create_category($title);

    # Create children category
    $rs->create_category($title, $parent_id);

Create category.

Return Value: L<$result|DBIx::Class::Manual::ResultClass> | undef

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

Yetie authors.

=head1 SEE ALSO

L<Yetie::Schema::Base::ResultSet>, L<Yetie::Schema>
