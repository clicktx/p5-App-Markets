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

subtest 'find' => sub {
    my @entities;
    Yetie::Domain::Entity->attr( [qw(hoge)] );
    push @entities, Yetie::Domain::Entity->new($_) for @data;

    my $c = $pkg->new(@entities);
    is $c->find(2)->{hoge}, 2, 'right found entity';
    is $c->find(5), undef, 'right not found entity';

    # Empty array
    $c = $pkg->new();
    is $c->find(1), undef, 'right empty collection';
};

subtest 'push' => sub {
    my $c = $pkg->new;

    $c->push(1);
    $c->push( ( 2, 3 ) );
    is $c->size,  3, 'right size';
    is $c->first, 1, 'right first element';
    is $c->last,  3, 'right last element';
};

subtest 'to_data' => sub {
    use Yetie::Domain::Collection qw/collection/;
    my $c = $pkg->new( collection(), 1, collection( collection(), collection( 1, 2 ) ), 2 );
    cmp_deeply $c->to_data, [ [], 1, [ [], [ 1, 2 ] ], 2 ], 'right dump data';
};

done_testing();
