package Markets::Schema::ResultSet::Category;
use Mojo::Base 'Markets::Schema::Base::ResultSet';

sub get_tree {
    my $self = shift;

    my @res;
    my $rs = $self->search( { parent_id => 0 } );
    while ( my $node = $rs->next ) {
        push @res, $self->get_children($node);
    }
    return \@res;
}

sub get_children {
    my ( $self, $node ) = @_;
    my $res = {};
    $res->{title} = $node->name;
    $res->{key}   = $node->id;
    my @kids = $node->children;
    $res->{expand} = 1;
    if (@kids) {
        my @children;
        foreach (@kids) {
            push @children, [ $self->get_children($_) ];
        }
        $res->{children} = \@children;
    }
    return $res;
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
