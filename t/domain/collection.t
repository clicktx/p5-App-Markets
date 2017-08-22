use Mojo::Base -strict;
use Test::More;
use Test::Deep;

use_ok 'Markets::Domain::Entity';
use_ok 'Markets::Domain::Collection';

my @data = ( { id => 1, hoge => 1 }, { id => 2, hoge => 2 }, { id => 3, hoge => 3 }, );

subtest 'basic' => sub {
    isa_ok Markets::Domain::Collection->new(), 'Mojo::Collection';
};

my @entities;
Markets::Domain::Entity->attr( [qw(hoge)] );
push @entities, Markets::Domain::Entity->new($_) for @data;

subtest 'each' => sub {
    my $c = Markets::Domain::Collection->new( 1, 2, 3 );
    my @idx;
    $c->each( sub { my ( $e, $i ) = @_; push @idx, $i } );
    is_deeply \@idx, [ 0, 1, 2 ], 'right';
};

subtest 'find' => sub {
    my $c = Markets::Domain::Collection->new(@entities);
    is $c->find(2)->{hoge}, 2, 'right found entity';
    is $c->find(5), undef, 'right not found entity';

    # Empty array
    $c = Markets::Domain::Collection->new();
    is $c->find(1), undef, 'right empty collection';
};

subtest 'to_data' => sub {
    use Markets::Domain::Collection qw/collection/;
    my $c = Markets::Domain::Collection->new( collection(), 1, collection( collection(), collection( 1, 2 ) ), 2 );
    cmp_deeply $c->to_data, [ [], 1, [ [], [ 1, 2 ] ], 2 ], 'right dump data';
};

done_testing();
