use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::CategoryTree';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::CategoryTree->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'level';
    can_ok $e, 'root_id';
    can_ok $e, 'title';
    can_ok $e, 'children';
};

subtest 'has_child' => sub {
    my $e = Yetie::Domain::Entity::CategoryTree->new( children => [ {} ] );
    is $e->has_child, 1, 'right has child';
    $e = Yetie::Domain::Entity::CategoryTree->new( children => [] );
    is $e->has_child, 0, 'right has not child';
};

done_testing();
