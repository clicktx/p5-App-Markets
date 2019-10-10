package Yetie::Domain::Collection;
use Mojo::Base 'Mojo::Collection';
use Scalar::Util qw/blessed/;

our @EXPORT_OK = qw(c collection);

sub append { return c( @{ shift->to_array }, @_ ) }

sub c { return collection(@_) }

sub collection { return __PACKAGE__->new(@_) }

sub get {
    my ( $self, $index ) = ( shift, shift // q{} );
    return if $index eq q{};

    return $self->[$index];
}

sub get_by_id {
    my ( $self, $str ) = @_;
    ( return $self->first( sub { $_->id eq $str } ) ) or undef;
}

sub get_by_line_num {
    my ( $self, $num ) = ( shift, shift // q{} );
    return if $num eq q{};

    return $self->get( $num - 1 );
}

sub has_element { return shift->get_by_id(shift) ? 1 : 0 }

sub rehash {
    my $self = shift;

    foreach my $element ( @{$self} ) {
        next if !Scalar::Util::blessed($element);
        next if !$element->can('rehash');

        $element->rehash;
    }
    return $self;
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

Yetie::Domain::Collection

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

L<Yetie::Domain::Collection> inherits all attributes from L<Mojo::Collection> and implements
the following new ones.

=head1 FUNCTIONS

=head2 C<c>

Alias L</collection>.

=head2 C<collection>

    my $collection = collection(1, 2, 3);

Construct a new array-based L<Yetie::Domain::Collection> object.

=head1 METHODS

L<Yetie::Domain::Collection> inherits all methods from L<Mojo::Collection> and implements
the following new ones.

=head2 C<append>

    my $new = $collection->append($str);
    my $new = $collection->append(@array);

Create a new collection with append elements.

Return L<Yetie::Domain::Collection> object.

=head2 C<each>

    $collection->each( sub {
        my ( $element, $num ) = @_;
        ...
    });

See L<Mojo::Collection/each>.

=head2 C<get>

    my $element = $collection->get($index);

    # Equivalent behavior
    my $element = $collection->[$index];

Return $element or undef.

=head2 C<get_by_id>

    my $entity = $collection->get_by_id($entity_id);

Return L<Yetie::Domain::Entity> object or undef.

=head2 C<get_by_line_num>

    my $element = $collection->get($line_num);

    # Equivalent behavior
    my $element = $collection->[ $line_num - 1 ];

Return $element or undef.

=head2 C<has_element>

    my $bool = $collection->has_element($entity_id);

Return boolean value.

=head2 C<rehash>

    $collection->rehash;

Recursive rehash for collection elements.

See L<Yetie::Domain::Base/rehash>

=head2 C<to_data>

    my $data = $collection->to_data;

Turn collection into array reference. This method recursive call L<Mojo::Collection/to_array>.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

L<Mojo::Collection>
