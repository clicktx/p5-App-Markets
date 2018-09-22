use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Collection qw(c);

my $pkg = 'Yetie::Domain::List';
use_ok $pkg;

my $construct = sub {
    my $list = c(@_);
    $pkg->new( list => $list );
};

subtest 'basic' => sub {
    my $v = $pkg->new();
    isa_ok $v->list, 'Yetie::Domain::Collection', 'right attribute list';
    can_ok $v, (qw(each get get_by_id first last size to_array));
};

subtest 'append' => sub {
    my $v = $construct->( 1, 2, 3 );
    $v->append(4);
    is_deeply $v->to_data, [ 1, 2, 3, 4 ], 'right append';
    is $v->is_modified, 1, 'right modified';
};

subtest 'clear' => sub {
    my $v = $construct->( 1, 2, 3 );
    $v->clear;
    is_deeply $v->to_data, [], 'right clear';
    is $v->is_modified, 1, 'right modified';
};

subtest 'each' => sub {
    my $v = $construct->( 1, 2, 3 );
    my @elements = $v->each;
    is_deeply \@elements, [ 1, 2, 3 ], 'right elements';
    my $int = $v->each;
    is $int, 3, 'right count elements';

    my @array;
    my $list = $v->each( sub { push @array, $_ } );
    isa_ok $list, $pkg;
    is_deeply \@array, [ 1, 2, 3 ], 'right function in each';
};

subtest 'to_data' => sub {
    my $v = $construct->( 1, 2, 3 );
    is_deeply $v->to_data, [ 1, 2, 3 ], 'right dump data';
};

done_testing();
