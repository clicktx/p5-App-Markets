use Mojo::Base -strict;
use Test::More;
use Test::Deep;

use_ok 'Markets::Domain::IxHash';

use DDP;
my $h = Markets::Domain::IxHash->new( a => 10, b => 20, c => 30, d => 40, e => 50 );

subtest 'attributes'=> sub {
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
};

subtest 'keys' => sub {
    my $keys = $h->keys;
    my @keys = $h->keys;
    is_deeply $keys,  [qw/a b c d e/];
    is_deeply \@keys, [qw/a b c d e/];
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

done_testing();
