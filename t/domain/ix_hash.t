use Mojo::Base -strict;
use Test::More;
use Test::Deep;

use_ok 'Markets::Domain::IxHash';

use DDP;
my $h = Markets::Domain::IxHash->new( a => 10, b => 20, c => 30, d => 40, e => 50 );

subtest 'attributes' => sub {
    can_ok $h, $_ for $h->keys;
};

subtest 'each' => sub {
    my %key_value = $h->each;
    cmp_deeply \%key_value, { a => 10, b => 20, c => 30, d => 40, e => 50 };

    my @data;
    $h->each(
        sub {
            my ( $key, $value, $num ) = @_;
            push @data, ( $key, $value, $num );
        }
    );
    cmp_deeply \@data, [qw/a 10 1 b 20 2 c 30 3 d 40 4 e 50 5/];

    @data = ();
    $h->each( sub { push @data, ( $a, $b, $_[2] ) } );
    cmp_deeply \@data, [qw/a 10 1 b 20 2 c 30 3 d 40 4 e 50 5/];
};

subtest 'first' => sub {
    my ( $key, $value ) = $h->first;
    is $key,   'a';
    is $value, 10;

    # Regex
    ( $key, $value ) = $h->first( [qr/b/] );
    is $key,   'b';
    is $value, '20';
    ( $key, $value ) = $h->first( [ undef, qr/2/ ] );
    is $key,   'b';
    is $value, '20';
    ( $key, $value ) = $h->first( [ qr/c/, qr/3/ ] );
    is $key,   'c';
    is $value, '30';
    ( $key, $value ) = $h->first( [ qr/a/, qr/2/ ] );
    is $key,   undef;
    is $value, undef;

    # Function
    ( $key, $value ) = $h->first( sub { my ( $key, $value ) = @_; $value > 30 } );
    is $key,   'd';
    is $value, '40';
    ( $key, $value ) = $h->first( sub { $a eq 'd' } );
    is $key,   'd';
    is $value, '40';
    ( $key, $value ) = $h->first( sub { $b > 30 } );
    is $key,   'd';
    is $value, '40';
};

subtest 'grep' => sub {
    my $new;

    # Regex
    $new = $h->grep( [ qr//, qr// ] );
    isa_ok $new, 'Markets::Domain::IxHash';
    is_deeply \@{ $new->pairs }, [qw/a 10 b 20 c 30 d 40 e 50/];
    $new = $h->grep( [ qr/c|e/, qr// ] );
    is_deeply \@{ $new->pairs }, [qw/c 30 e 50/];
    $new = $h->grep( [ undef, qr/3|5/ ] );
    is_deeply \@{ $new->pairs }, [qw/c 30 e 50/];
    $new = $h->grep( [ qr/c/, qr/3|5/ ] );
    is_deeply \@{ $new->pairs }, [qw/c 30/];

    # Function
    $new = $h->grep( sub { } );
    is_deeply \@{ $new->pairs }, [];
    $new = $h->grep( sub { 1 } );
    is_deeply \@{ $new->pairs }, [qw/a 10 b 20 c 30 d 40 e 50/];
    $new = $h->grep( sub { my ( $key, $value ) = @_; $key eq 'c' or $key eq 'e' } );
    is_deeply \@{ $new->pairs }, [qw/c 30 e 50/];
    $new = $h->grep( sub { my ( $key, $value ) = @_; $value > 20 } );
    is_deeply \@{ $new->pairs }, [qw/c 30 d 40 e 50/];

    $new = $h->grep( sub { $a eq 'c' or $a eq 'e' } );
    is_deeply \@{ $new->pairs }, [qw/c 30 e 50/];
    $new = $h->grep( sub { $b > 20 } );
    is_deeply \@{ $new->pairs }, [qw/c 30 d 40 e 50/];
};

subtest 'keys' => sub {
    my $keys = $h->keys;
    my @keys = $h->keys;
    is_deeply $keys,  [qw/a b c d e/];
    is_deeply \@keys, [qw/a b c d e/];
};

subtest 'last' => sub {
    my ( $key, $value ) = $h->last;
    is $key,   'e';
    is $value, 50;
};

subtest 'map' => sub {
    my $new;
    $new = $h->map( sub { } );
    isa_ok $new, 'Markets::Domain::IxHash';
    is_deeply \@{ $new->pairs }, [];
    $new = $h->map( sub { my ( $key, $value ) = @_; $key => $value + 1 } );
    is_deeply \@{ $new->pairs }, [qw/a 11 b 21 c 31 d 41 e 51/];
    $new = $h->map( sub { $a => $b + 1 } );
    is_deeply \@{ $new->pairs }, [qw/a 11 b 21 c 31 d 41 e 51/];
};

subtest 'pairs' => sub {
    my $array = $h->pairs;
    my @array = $h->pairs;
    is_deeply $array,  [qw/a 10 b 20 c 30 d 40 e 50/];
    is_deeply \@array, [qw/a 10 b 20 c 30 d 40 e 50/];
};

subtest 'size' => sub {
    my $size = $h->size;
    is $size, 5;
};

subtest 'to_hash' => sub {
    my $hash_ref = $h->to_hash;
    cmp_deeply $hash_ref, { a => 10, b => 20, c => 30, d => 40, e => 50 };
};

subtest 'to_data' => sub {
    use Markets::Domain::IxHash qw/ix_hash/;
    my $h = ix_hash(
        a => ix_hash( a1 => ix_hash( a2 => 1 ) ),
        b => { b1        => 2 },
        c => 3
    );
    my $data = $h->to_data;
    cmp_deeply $data, { a => { a1 => { a2 => 1 } }, b => { b1 => 2 }, c => 3 };
};

subtest 'values' => sub {
    my $values = $h->values;
    my @values = $h->values;
    is_deeply $values,  [qw/10 20 30 40 50/];
    is_deeply \@values, [qw/10 20 30 40 50/];
};

done_testing();
