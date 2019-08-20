use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::CategoryTreeRoot';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::CategoryTreeRoot->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'children';
    isa_ok $e->children, 'Yetie::Domain::List::CategoryTrees';
};

subtest 'create_index' => sub {
    my $f     = Yetie::Factory->new('entity-category_tree_root');
    my $e     = $f->construct( children => [ { id => 1 }, { id => 2 } ] );
    my $index = $e->_index;

    $e->set_index( {} );
    ok !eq_deeply( $e->_index, $index ), 'right set index';

    $e->create_index;
    cmp_deeply $e->_index, $index, 'right create index';
};

subtest 'get_attributes_for_choices_form' => sub {
    my $f = Yetie::Factory->new('entity-category_tree_root');
    my $e = $f->construct( children =>
          [ { id => 1, title => 'foo' }, { id => 2, title => 'bar', children => [ { id => 3, title => 'baz' } ] } ] );
    my $choices = $e->get_attributes_for_choices_form;
    is_deeply $choices, [ [ 'foo', 1 ], [ 'bar', 2 ], [ 'baz', 3 ] ], 'right form choices';

    $choices = $e->get_attributes_for_choices_form( [2] );
    is_deeply $choices, [ [ 'foo', 1 ], [ 'bar', 2, choiced => 1 ], [ 'baz', 3 ] ], 'right form choices';
};

subtest 'get_node' => sub {
    my $f = Yetie::Factory->new('entity-category_tree_root');
    my $e = $f->construct( children => [] );
    is $e->get_node(1), undef, 'right not has node';

    $e = $f->construct( children => [ { id => 1 }, { id => 2 } ] );
    isa_ok $e->get_node(1), 'Yetie::Domain::Entity::CategoryTreeNode', 'right gets node';
    is $e->get_node(2)->id, 2, 'right gets node';
    is $e->get_node(999), undef, 'right not has node';
};

subtest 'has_child' => sub {
    my $f = Yetie::Factory->new('entity-category_tree_root');
    my $e = $f->construct( children => [ {} ] );
    is $e->has_child, 1, 'right has child';
    $e = $f->construct( children => [] );
    is $e->has_child, 0, 'right has not child';
};

done_testing();
