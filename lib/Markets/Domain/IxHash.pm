package Markets::Domain::IxHash;
use Mojo::Base -base;

use Exporter 'import';
use List::Util;
use Scalar::Util 'blessed';
use Tie::IxHash;

our @EXPORT_OK = ('ix_hash');

sub ix_hash { __PACKAGE__->new(@_) }

sub each {
    my ( $self, $cb ) = @_;
    return %{$self} unless $cb;
    my $i = 1;
    $_->$cb( $self->{$_}, $i++ ) for $self->keys;

    return $self;
}

sub first {
    my ( $self, $cb ) = ( shift, shift );
    my @keys = $self->keys;
    return $keys[0] => $self->{ $keys[0] } unless $cb;
    return ( List::Util::pairfirst { $a =~ ( $cb->[0] || qr// ) && $b =~ ( $cb->[1] || qr// ) } %{$self} )
      if ref $cb eq 'ARRAY';
    return ( List::Util::pairfirst { $cb->( $a, $b ) } %{$self} );
}

sub grep {
    my ( $self, $cb ) = ( shift, shift );
    return $self->new( List::Util::pairgrep { $a =~ ( $cb->[0] || qr// ) && $b =~ ( $cb->[1] || qr// ) } %{$self} )
      if ref $cb eq 'ARRAY';
    return $self->new( List::Util::pairgrep { $cb->( $a, $b ) } %{$self} );
}

sub keys {
    my @keys = keys %{ shift() };
    return wantarray ? @keys : \@keys;
}

sub last { ( @{ $_[0]->keys }[-1], @{ $_[0]->values }[-1] ) }

sub new {
    my $class = shift;

    my %hash;
    tie %hash, 'Tie::IxHash';
    %hash = @_;
    my $obj = bless \%hash, ref $class || $class;

    $obj->attr( \@{ $obj->keys } );
    return $obj;
}

sub pairs {
    my @array = %{ shift() };
    wantarray ? @array : \@array;
}

sub size { scalar @{ shift->keys } }

sub to_data {
    my $self = shift;

    my %data;
    $self->each(
        sub {
            my ( $k, $v ) = @_;
            $data{$k} = blessed $v ? $v->to_data : $v;
        }
    );
    return \%data;
}

sub to_hash { +{ %{ shift() } } }

sub values {
    my @values = values %{ shift() };
    return wantarray ? @values : \@values;
}

1;
__END__

=head1 NAME

Markets::Domain::IxHash

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 FUNCTIONS

=head2 C<ix_hash>

    my $collection = collection(1, 2, 3);

Construct a new index-hash-based L<Markets::Domain::IxHash> object.

=head1 METHODS

=head2 C<each>

    my %key_value = $ix_hash->each;
    $ix_hash  = $ix_hash->each(sub {...});

    # Make a numbered key value pair
    $ix_hash->each(sub {
      my ($key, $value, $num) = @_;
      say "$num: $key => $value";
    });

=head2 C<first>

    my ( $key, $value ) = $ix_hash->first;
    my ( $key, $value ) = $ix_hash->first( [ qr//, qr// ] );
    my ( $key, $value ) = $ix_hash->first( sub {...} );

    # Find first key-value pair that "key" contains the word "mojo"
    my ( $key, $value ) = $collection->first([ qr/mojo/i ]);
    # Find first key-value pair that "value" contains the word "jo"
    my ( $key, $value ) = $collection->first([ undef, qr/jo/i ]);
    # Find first key-value pair that "key" contains the word "mo" and "value" contains the word "jo"
    my ( $key, $value ) = $collection->first([ qr/mo/i, qr/jo/i ]);

    # Find first key-value pair that value is greater than 5
    my ( $key, $value ) = $ix_hash->first( sub { my ( $key, $value ) = @_; $value > 5 } );

=head2 C<grep>

    my $new = $ix_hash->grep( [ qr//, qr// ] );
    my $new = $ix_hash->grep( sub {...} );

=head2 C<keys>

    my @keys = $ix_hash->keys;
    my $keys = $ix_hash->keys;

=head2 C<last>

    my ( $key, $value ) = $ix_hash->last;

Return the last key-value pair.

=head2 C<pairs>

    my $array = $ix_hash->pairs;
    my @array = $ix_hash->pairs;

=head2 C<size>

    my $size = $ix_hash->size;

Number of key-value pair in IxHash.

=head2 C<to_data>

    my $hash_ref = $ix_hash->to_data;

=head2 C<to_hash>

    my $hash = $ix_hash->to_hash;

Turn IxHash into hash reference.

=head1 AUTHOR

Markets authors.

=head1 SEE ALSO

 L<Tie::IxHash>
