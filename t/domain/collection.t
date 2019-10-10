use Mojo::Base -strict;
use Test::More;
use Test::Deep;

my $pkg = 'Yetie::Domain::Collection';
use_ok $pkg;

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
    is $c->get(0), 1,     'right get element';
    is $c->get(2), 3,     'right get element';
    is $c->get(4), undef, 'right has not element';
    is $c->get(), undef, 'right has not element';
    is $c->get(''), undef, 'right has not element';
};

{

    package t::domain::entity;
    use Moose;
    extends 'Yetie::Domain::Entity';
    has foo => ( is => 'ro' );
}
my @data = ( { id => 1, foo => 1 }, { id => 2, foo => 2 }, { id => 3, foo => 3 }, );

subtest 'get_by_id' => sub {
    my @entities;
    push @entities, t::domain::entity->new($_) for @data;

    my $c = $pkg->new(@entities);
    is $c->get_by_id(2)->{foo}, 2, 'right found entity';
    is $c->get_by_id(5), undef, 'right not found entity';

    # Empty array
    $c = $pkg->new();
    is $c->get_by_id(1), undef, 'right empty collection';
};

subtest 'get_by_line_num' => sub {
    my $c = $pkg->new( 1, 2, 3 );
    is $c->get_by_line_num(1), 1,     'right get element';
    is $c->get_by_line_num(3), 3,     'right get element';
    is $c->get_by_line_num(4), undef, 'right has not element';
    is $c->get_by_line_num(), undef, 'right has not element';
    is $c->get_by_line_num(''), undef, 'right has not element';
};

subtest 'has_element' => sub {
    my @entities;
    push @entities, t::domain::entity->new($_) for @data;

    my $c = $pkg->new(@entities);
    is $c->has_element(2), 1, 'right has element';
    is $c->has_element(5), 0, 'right has not element';

    # Empty array
    $c = $pkg->new();
    is $c->has_element(1), 0, 'right has not element';
};

subtest 'rehash' => sub {
    my @entities;
    push @entities, t::domain::entity->new($_) for @data;
    my $c = $pkg->new(@entities);

    my $hash_sum = $c->[1]->_hash_sum;
    $c->[1]->_set_hash_sum('foo');

    my $res = $c->rehash;
    is $c->[1]->_hash_sum, $hash_sum, 'right rehash';
    is $res, $c, 'right return';
};

subtest 'to_data' => sub {
    use Yetie::Domain::Collection qw/collection/;
    my $c = $pkg->new( collection(), 1, collection( collection(), collection( 1, 2 ) ), 2 );
    cmp_deeply $c->to_data, [ [], 1, [ [], [ 1, 2 ] ], 2 ], 'right dump data';
};

done_testing();
