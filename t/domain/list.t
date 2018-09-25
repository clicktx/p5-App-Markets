use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::List';
use_ok $pkg;

sub construct {
    my $list = c(@_);
    $pkg->new( list => $list );
}

subtest 'basic' => sub {
    my $l = $pkg->new();
    isa_ok $l->list, 'Yetie::Domain::Collection', 'right attribute list';
    can_ok $l, (qw(each get get_by_id first last size to_array));
};

subtest 'append' => sub {
    my $l = construct( 1, 2, 3 );
    $l->append(4);
    is_deeply $l->to_data, [ 1, 2, 3, 4 ], 'right append';
    is $l->is_modified, 1, 'right modified';
};

subtest 'clear' => sub {
    my $l = construct( 1, 2, 3 );
    $l->clear;
    is_deeply $l->to_data, [], 'right clear';
    is $l->is_modified, 1, 'right modified';
};

subtest 'count' => sub {
    my $l = construct( 1, 2, 3 );
    my $int = $l->count;
    is $int, 3, 'right count';
};

subtest 'each' => sub {
    my $l = construct( 1, 2, 3 );
    my @elements = $l->each;
    is_deeply \@elements, [ 1, 2, 3 ], 'right elements';
    my $int = $l->each;
    is $int, 3, 'right count elements';

    my @array;
    my $list = $l->each( sub { push @array, $_ } );
    isa_ok $list, $pkg;
    is_deeply \@array, [ 1, 2, 3 ], 'right function in each';
};

subtest 'to_data' => sub {
    my $l = construct( 1, 2, 3 );
    is_deeply $l->to_data, [ 1, 2, 3 ], 'right dump data';
};

done_testing();
