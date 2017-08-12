package Markets::Schema::ResultSet::Category;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub get_tree_for_form {
    my ( $self, $opt, $values ) = @_;
    $values = [$values] unless ref $values;

    my @tree;
    my @root_nodes = $self->search( { level => 0 } );
    foreach my $node (@root_nodes) {
        my $data = [ $node->title => $node->id ];
        push @{$data}, _opt( $node->id, $opt => $values );
        push @tree, $data;
        my $itr = $node->descendants;
        while ( my $desc = $itr->next ) {
            my $data = [ '¦   ' x $desc->level . $desc->title => $desc->id ];
            push @{$data}, _opt( $desc->id, $opt => $values );
            push @tree, $data;
        }
    }
    return \@tree;
}

sub _opt {
    my ( $id, $opt, $values ) = @_;

    foreach my $v ( @{$values} ) {
        return ( $opt => 1 ) if $v == $id;
    }
    return ();
}

1;
__END__
=encoding utf8

=head1 NAME

Markets::Schema::ResultSet::Category

=head1 SYNOPSIS

    my $data = $schema->resultset('Category')->method();

=head1 DESCRIPTION

=head1 METHODS

=head2 C<get_tree_for_form>

    my $tree = $rs->get_tree_for_form();

    my $tree = $rs->get_tree_for_form( checked  => 3 );
    my $tree = $rs->get_tree_for_form( selected => 7 );

    my $tree = $rs->get_tree_for_form( checked  => [ 1, 3, 5 ] );

Return Array refference.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
