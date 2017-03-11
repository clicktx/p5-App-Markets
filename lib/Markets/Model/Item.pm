package Markets::Model::Item;
use Mojo::Base 'Markets::Model';

sub to_array {
    my ( $self, $order_id, $items ) = @_;

    my @keys = sort( keys( %{ $items->[0] } ), 'order_id' );
    push my @converted, \@keys;

    foreach my $row ( @{$items} ) {
        $row->{order_id} = $order_id;
        my @values = @{$row}{@keys};
        push @converted, \@values;
    }

    return \@converted;
}

1;
__END__

=head1 NAME

Markets::Model::Item

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 C<to_array>

    my $converted_data = $c->model('item')->to_array($order_id, \@items);

    # eg.
    my $order_id = 33;
    my $data = $c->model('item')->to_array(
        $order_id,
        [
            { bb => 5, aa => 3, zz => 15 },
            { bb => 7, aa => 6, zz => 15 },
        ]
    );

    # Return value
    print Dumper $data;
    \[
        [ qw/aa bb order_id zz/ ],
        [3, 5, 33, 15],
        [6, 7, 33, 15],
    ];

Convert the data structure.

What to use?
See bulk insert method L<DBIx::Class/populate>.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

L<Markets::Model> L<Mojolicious::Plugin::Model> L<MojoX::Model>
