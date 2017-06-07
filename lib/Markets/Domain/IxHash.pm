package Markets::Domain::IxHash;
use Mojo::Base -base;

use Exporter 'import';
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

sub keys {
    my @keys = keys %{ shift() };
    return wantarray ? @keys : \@keys;
}

sub new {
    my $class = shift;

    my %hash;
    tie %hash, 'Tie::IxHash';
    %hash = @_;
    my $obj = bless \%hash, ref $class || $class;

    $obj->attr( \@{ $obj->keys } );
    return $obj;
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

=head2 C<keys>

    my @keys = $ix_hash->keys;
    my $keys = $ix_hash->keys;

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
