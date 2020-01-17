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
    can_ok $l, (qw(each get get_by_id first last to_array));
};

subtest 'append' => sub {
    my $l = construct( 1, 2, 3 );
    my $res = $l->append(4);
    is $res, undef, 'right return value';
    is_deeply $l->to_data, [ 1, 2, 3, 4 ], 'right append';
    is $l->is_modified, 1, 'right modified';
};

subtest 'append_new' => sub {
    my $l = construct();
    my $obj = $l->append_new( 'entity' => { id => 222 } );
    is $l->size, 1, 'right create sales_order';
    isa_ok $obj, 'Yetie::Domain::Entity';
    isa_ok $l->first, 'Yetie::Domain::Entity';
    is $l->first->id, 222, 'right construct with arguments';

    my $obj2 = $l->append_new('entity');
    is $l->size, 2, 'right recreate sales_order';
    isnt $obj, $obj2, 'right compare object';
};

subtest 'clear' => sub {
    my $l = construct( 1, 2, 3 );
    $l->clear;
    is_deeply $l->to_data, [], 'right clear';
    is $l->is_modified, 1, 'right modified';
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

subtest 'grep' => sub {
    my $l = construct( 1, 2, 3 );
    is_deeply $l->grep(qr/2/)->to_data, [2], 'right grep';
};

subtest 'has_elements' => sub {
    my $l = construct();
    ok !$l->has_elements, 'right has not elements';

    $l = construct( 1, 2, 3 );
    ok $l->has_elements, 'right has elements';
};

subtest 'map' => sub {
    my $l = construct( 1, 2, 3 );
    is_deeply $l->map( sub { ++$_ } )->to_data, [ 2, 3, 4 ], 'right map';
};

subtest 'reduce' => sub {
    my $l = construct( 1, 2, 3 );
    is $l->reduce( sub { $a + $b } ), 6, 'right reduce';
};

subtest 'size' => sub {
    my $l = construct( 1, 2, 3 );
    is $l->size, 3, 'right size';
};

subtest 'to_data' => sub {
    my $l = construct( 1, 2, 3 );
    is_deeply $l->to_data,       [ 1, 2, 3 ], 'right dump data';
    is_deeply $l->to_order_data, [ 1, 2, 3 ], 'right dump order data';
};

done_testing();
