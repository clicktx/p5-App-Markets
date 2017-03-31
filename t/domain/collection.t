use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity';
use_ok 'Markets::Domain::Collection';

my @data = ( { id => 1, hoge => 1 }, { id => 2, hoge => 2 }, { id => 3, hoge => 3 }, );

subtest 'basic' => sub {
    isa_ok Markets::Domain::Collection->new(), 'Markets::Domain::Collection';
    eval { Markets::Domain::Collection->new(@data) };
    ok $@, 'right constructor';
};

my @entities;
push @entities, Markets::Domain::Entity->new($_) for @data;

subtest 'find method' => sub {
    my $c = Markets::Domain::Collection->new(@entities);
    is $c->find(2)->{hoge}, 2, 'right found entity';
    is $c->find(5), undef, 'right not found entity';

    # Empty array
    $c = Markets::Domain::Collection->new();
    is $c->find(1), undef, 'right empty collection';
};

done_testing();
