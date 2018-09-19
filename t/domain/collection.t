use Mojo::Base -strict;
use Test::More;
use Test::Deep;

use_ok 'Yetie::Domain::Entity';

my $pkg = 'Yetie::Domain::Collection';
use_ok $pkg;

my @data = ( { id => 1, hoge => 1 }, { id => 2, hoge => 2 }, { id => 3, hoge => 3 }, );

subtest 'basic' => sub {
    isa_ok $pkg->new(), 'Mojo::Collection';

    my $c = Yetie::Domain::Collection::c( 1, 2, 3 );
    is_deeply $c, [ 1, 2, 3 ], 'right c()';

    $c = Yetie::Domain::Collection::collection( 1, 2, 3 );
    is_deeply $c, [ 1, 2, 3 ], 'right collection()';
};

subtest 'append' => sub {
    my $c = $pkg->new();

    my $new = $c->append(1);
    is_deeply $c->to_array, [], 'immutable';
    is_deeply $new->to_array, [1], 'right append element';

    $new = $new->append( 2, 3 );
    is_deeply $new->to_array, [ 1, 2, 3 ], 'right append elements';
};

subtest 'get' => sub {
    my $c = $pkg->new( 1, 2, 3 );
    is $c->get(1), 2,     'right get element';
    is $c->get(4), undef, 'right has not element';
};

subtest 'get_by_id' => sub {
    my @entities;
    Yetie::Domain::Entity->attr( [qw(hoge)] );
    push @entities, Yetie::Domain::Entity->new($_) for @data;

    my $c = $pkg->new(@entities);
    is $c->get_by_id(2)->{hoge}, 2, 'right found entity';
    is $c->get_by_id(5), undef, 'right not found entity';

    # Empty array
    $c = $pkg->new();
    is $c->get_by_id(1), undef, 'right empty collection';
};

subtest 'has' => sub {
    my @entities;
    Yetie::Domain::Entity->attr( [qw(hoge)] );
    push @entities, Yetie::Domain::Entity->new($_) for @data;

    my $c = $pkg->new(@entities);
    is $c->has(2), 1, 'right has element';
    is $c->has(5), 0, 'right has not element';

    # Empty array
    $c = $pkg->new();
    is $c->has(1), 0, 'right has not element';
};

subtest 'to_data' => sub {
    use Yetie::Domain::Collection qw/collection/;
    my $c = $pkg->new( collection(), 1, collection( collection(), collection( 1, 2 ) ), 2 );
    cmp_deeply $c->to_data, [ [], 1, [ [], [ 1, 2 ] ], 2 ], 'right dump data';
};

done_testing();
