use Mojo::Base -strict;
use Test::More;
use Test::Deep;

use_ok 'Yetie::Domain::Entity';
use_ok 'Yetie::Domain::Collection';

my @data = ( { id => 1, hoge => 1 }, { id => 2, hoge => 2 }, { id => 3, hoge => 3 }, );

subtest 'basic' => sub {
    isa_ok Yetie::Domain::Collection->new(), 'Mojo::Collection';

    my $c = Yetie::Domain::Collection::c( 1, 2, 3 );
    is_deeply $c, [ 1, 2, 3 ], 'right c()';

    $c = Yetie::Domain::Collection::collection( 1, 2, 3 );
    is_deeply $c, [ 1, 2, 3 ], 'right collection()';
};

subtest 'find' => sub {
    my @entities;
    Yetie::Domain::Entity->attr( [qw(hoge)] );
    push @entities, Yetie::Domain::Entity->new($_) for @data;

    my $c = Yetie::Domain::Collection->new(@entities);
    is $c->find(2)->{hoge}, 2, 'right found entity';
    is $c->find(5), undef, 'right not found entity';

    # Empty array
    $c = Yetie::Domain::Collection->new();
    is $c->find(1), undef, 'right empty collection';
};

subtest 'to_data' => sub {
    use Yetie::Domain::Collection qw/collection/;
    my $c = Yetie::Domain::Collection->new( collection(), 1, collection( collection(), collection( 1, 2 ) ), 2 );
    cmp_deeply $c->to_data, [ [], 1, [ [], [ 1, 2 ] ], 2 ], 'right dump data';
};

done_testing();
