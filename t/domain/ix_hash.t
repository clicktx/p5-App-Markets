use Mojo::Base -strict;
use Test::More;
use Test::Deep;

my $pkg = 'Yetie::Domain::IxHash';
use_ok $pkg;

my $h = $pkg->new( a => 10, b => 20, c => 30, d => 40, e => 50 );

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

    my $pair = $h->first;
    is_deeply $pair, { a => 10 };

    # Regex
    ( $key, $value ) = $h->first( { key => qr/b/ } );
    is $key,   'b';
    is $value, '20';
    ( $key, $value ) = $h->first( { value => qr/2/ } );
    is $key,   'b';
    is $value, '20';
    ( $key, $value ) = $h->first( { key => qr/c/, value => qr/3/ } );
    is $key,   'c';
    is $value, '30';
    ( $key, $value ) = $h->first( { key => qr/a/, value => qr/2/ } );
    is $key,   undef;
    is $value, undef;

    # Code reference
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
    $new = $h->grep( { key => qr//, value => qr// } );
    isa_ok $new, $pkg;
    is_deeply \@{ $new->pairs }, [qw/a 10 b 20 c 30 d 40 e 50/];
    $new = $h->grep( { key => qr/c|e/ } );
    is_deeply \@{ $new->pairs }, [qw/c 30 e 50/];
    $new = $h->grep( { value => qr/3|5/ } );
    is_deeply \@{ $new->pairs }, [qw/c 30 e 50/];
    $new = $h->grep( { key => qr/c/, value => qr/3|5/ } );
    is_deeply \@{ $new->pairs }, [qw/c 30/];

    # Code reference
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
    is_deeply $keys,  [qw/a b c d e/], 'right return array ref';
    is_deeply \@keys, [qw/a b c d e/], 'right return array';
};

subtest 'last' => sub {
    my ( $key, $value ) = $h->last;
    is $key,   'e',  'right last key';
    is $value, '50', 'right last value';

    my $pair = $h->last;
    is_deeply $pair, { e => 50 }, 'right last pair';
};

subtest 'map' => sub {
    my $new;
    $new = $h->map( sub { } );
    isa_ok $new, $pkg;
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

{

    package t::domain::entity;
    use Moose;
    extends 'Yetie::Domain::Entity';
    has foo => ( is => 'ro' );
}
my @data = ( { id => 1, foo => 1 }, { id => 2, foo => 2 }, { id => 3, foo => 3 }, );

subtest 'rehash' => sub {
    my @entities;
    push @entities, t::domain::entity->new($_) for @data;

    my $ix = $pkg->new( a => $entities[0], b => $entities[1], c => $entities[2] );
    my $hash_sum = $entities[1]->hash_sum;
    $entities[1]->_set_hash_sum('foo');

    my $res = $ix->rehash;
    is $ix->b->hash_sum, $hash_sum, 'right rehash';
    is $res, $ix, 'ritght return';
};

subtest 'size' => sub {
    my $size = $h->size;
    is $size, '5', 'right size';
};

subtest 'to_hash' => sub {
    my $hash_ref = $h->to_hash;
    cmp_deeply $hash_ref, { a => 10, b => 20, c => 30, d => 40, e => 50 };
};

subtest 'to_data' => sub {
    use Yetie::Domain::IxHash qw/ixhash/;
    my $h = ixhash(
        a => ixhash( a1 => ixhash( a2 => 1 ) ),
        b => { b1       => 2 },
        c => 3
    );
    my $data = $h->to_data;
    cmp_deeply $data, { a => { a1 => { a2 => 1 } }, b => { b1 => 2 }, c => 3 };
};

subtest 'values' => sub {
    my $values = $h->values;
    my @values = $h->values;
    is_deeply $values,  [qw/10 20 30 40 50/], 'right return array ref';
    is_deeply \@values, [qw/10 20 30 40 50/], 'right return array';
};

done_testing();
