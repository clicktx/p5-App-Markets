package Markets::Schema::ResultSet::Category;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub get_tree {
    my $self = shift;

    my @tree;
    my @root_nodes = $self->search( { level => 0 } );
    foreach my $node (@root_nodes) {
        push @tree, [ $node->title => $node->id ];
        my $itr = $node->descendants;
        while ( my $desc = $itr->next ) {
            push @tree, [ '¦   ' x $desc->level . $desc->title => $desc->id ];
        }
    }
    return \@tree;
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

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Schema::Base::ResultSet>, L<Markets::Schema>
