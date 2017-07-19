package Markets::Domain::Collection;
use Mojo::Base 'Mojo::Collection';
use Scalar::Util qw/blessed/;

our @EXPORT_OK = ('collection');

sub collection { __PACKAGE__->new(@_) }

# NOTE: 同じcollectionに同一のidを持つ要素は存在しないはずなのでsearchメソッドは不要？
sub find {
    my ( $self, $str ) = @_;
    $self->first( sub { $_->id eq $str } ) or undef;
}

sub to_data {
    my $self = shift;
    my @array;
    push @array, blessed $_ ? $_->to_data : $_ for @{ $self->to_array };
    return \@array;
}

1;
__END__

=head1 NAME

Markets::Domain::Collection

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Markets::Domain::Collection> inherits all attributes from L<Mojo::Collection> and implements
the following new ones.

=head1 FUNCTIONS

=head2 C<collection>

    my $collection = collection(1, 2, 3);

Construct a new array-based L<Markets::Domain::Collection> object.

=head1 METHODS

L<Markets::Domain::Collection> inherits all methods from L<Mojo::Collection> and implements
the following new ones.

=head2 C<find>

    my $entity = $collection->find($entity_id);

Return L<Markets::Domain::Entity> object or undef.

=head2 C<to_data>

    my $data = $collection->to_data;

Turn collection into array reference. This method recursive call L<Mojo::Collection/to_array>.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Mojo::Collection>
