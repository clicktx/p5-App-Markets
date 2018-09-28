package Yetie::Domain::IxHash;
use Mojo::Base -base;

use Exporter 'import';
use List::Util;
use Scalar::Util 'blessed';
use Tie::IxHash;

our @EXPORT_OK = ('ixhash');

sub ixhash { __PACKAGE__->new(@_) }

sub each {
    my ( $self, $cb ) = @_;
    return %{$self} unless $cb;

    my $i      = 1;
    my $caller = caller;
    foreach my $a ( @{ $self->keys } ) {
        my $b = $self->{$a};
        no strict 'refs';
        local ( *{"${caller}::a"}, *{"${caller}::b"} ) = ( \$a, \$b );
        $a->$cb( $b, $i++ );
    }
    return $self;
}

sub first {
    my ( $self, $cb ) = ( shift, shift );

    my @keys = $self->keys;
    my %pair = ();

    if ( !$cb ) { %pair = ( $keys[0] => $self->{ $keys[0] } ) }
    elsif ( ref $cb eq 'HASH' ) {    # Regex
        %pair = List::Util::pairfirst { $a =~ ( $cb->{key} || qr/.*/ ) && $b =~ ( $cb->{value} || qr/.*/ ) } %{$self};
    }
    else {                           # Code reference
        my $caller = caller;
        no strict 'refs';
        %pair = List::Util::pairfirst {
            local ( *{"${caller}::a"}, *{"${caller}::b"} ) = ( \$a, \$b );
            $a->$cb($b)
        }
        %{$self};
    }
    return wantarray ? %pair : \%pair;
}

sub grep {
    my ( $self, $cb ) = ( shift, shift );
    return $self->new(
        List::Util::pairgrep { $a =~ ( $cb->{key} || qr/.*/ ) && $b =~ ( $cb->{value} || qr/.*/ ) }
        %{$self}
    ) if ref $cb eq 'HASH';

    my $caller = caller;
    no strict 'refs';
    my @list = List::Util::pairgrep {
        local ( *{"${caller}::a"}, *{"${caller}::b"} ) = ( \$a, \$b );
        $a->$cb($b)
    }
    %{$self};
    return $self->new(@list);
}

sub keys {
    my @keys = keys %{ shift() };
    return wantarray ? @keys : \@keys;
}

sub last {
    my %pair = ( @{ $_[0]->keys }[-1], @{ $_[0]->values }[-1] );
    wantarray ? %pair : \%pair;
}

sub map {
    my ( $self, $cb ) = ( shift, shift );

    my $caller = caller;
    no strict 'refs';
    my @list = List::Util::pairmap {
        local ( *{"${caller}::a"}, *{"${caller}::b"} ) = ( \$a, \$b );
        $a->$cb($b);
    }
    %{$self};
    return $self->new(@list);
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

Yetie::Domain::IxHash

=head1 SYNOPSIS

    my $hash = ixhash( foo => 1, bar => 2, baz => 3 );

    # foo1 bar2 baz3
    $hash->each( sub { say $a, $b } );

=head1 DESCRIPTION

=head1 ATTRIBUTES

=head1 FUNCTIONS

=head2 C<ixhash>

    my $hash = ixhash( foo => 1, bar => 2, baz => 3 );

Construct a new index-hash-based L<Yetie::Domain::IxHash> object.

=head1 METHODS

L<Yetie::Domain::IxHash> inherits all methods from L<Mojo::Base> and implements
the following new ones.

=head2 C<each>

    my %key_value = $ixhash->each;
    $ixhash  = $ixhash->each(sub {...});

    # Make a numbered key value pair
    $ixhash->each( sub { say "num:$_[2] $a => $b" } );

    $ixhash->each( sub {
      my ($key, $value, $num) = @_;
      say "$num: $key => $value";
    });

=head2 C<first>

    my ( $key, $value ) = $ixhash->first;
    my ( $key, $value ) = $ixhash->first( { key => qr//, value => qr// } );
    my ( $key, $value ) = $ixhash->first( sub {...} );
    my $pair = $ixhash->first;      # Return hash reference

    # Find first key-value pair that "key" contains the word "mojo"
    my ( $key, $value ) = $collection->first( { key => qr/mojo/i } );

    # Find first key-value pair that "value" contains the word "jo"
    my ( $key, $value ) = $collection->first( { value => qr/jo/i } );

    # Find first key-value pair that "key" contains the word "mo" and "value" contains the word "jo"
    my ( $key, $value ) = $collection->first( { key => qr/mo/i, value => qr/jo/i } );

    # Find first key-value pair that key is 'hoge'
    my ( $key, $value ) = $ixhash->first( sub { $a eq 'hoge' } );
    my ( $key, $value ) = $ixhash->first( sub { my ( $key, $value ) = @_; $key eq 'hoge' } );

    # Find first key-value pair that value is greater than 5
    my ( $key, $value ) = $ixhash->first( sub { $b > 5 } );
    my ( $key, $value ) = $ixhash->first( sub { my ( $key, $value ) = @_; $value > 5 } );

=head2 C<grep>

    my $new = $ixhash->grep( { key => qr//, value => qr// } );
    my $new = $ixhash->grep( sub {...} );



    my $new = $ixhash->grep( sub { $a eq 'hoge' } );
    my $new = $ixhash->grep( sub { my ($key, $value) = @_; $key eq 'hoge' } );

    my $new = $ixhash->grep( sub { $b > 100 } );
    my $new = $ixhash->grep( sub { my ($key, $value) = @_; $value > 100 } );

=head2 C<keys>

    my @keys = $ixhash->keys;
    my $keys = $ixhash->keys;

=head2 C<last>

    my ( $key, $value ) = $ixhash->last;
    my $pair = $ixhash->last;

Return the last key-value pair.

=head2 C<map>

    my $new = $ixhash->map( sub {...} );

    my $new = $ixhash->map( sub { $a => $b + 1 } );
    my $new = $ixhash->map( sub { my ( $key, $value ) = @_; $key => $value + 1 } );

=head2 C<pairs>

    my $array = $ixhash->pairs;
    my @array = $ixhash->pairs;

=head2 C<size>

    my $size = $ixhash->size;

Number of key-value pair in IxHash.

=head2 C<to_data>

    my $hash_ref = $ixhash->to_data;

=head2 C<to_hash>

    my $hash = $ixhash->to_hash;

Turn IxHash into hash reference.

=head1 AUTHOR

Yetie authors.

=head1 SEE ALSO

 L<Tie::IxHash>
