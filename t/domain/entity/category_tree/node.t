use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::CategoryTree::Node';

subtest 'basic' => sub {
    my $p = Markets::Domain::Entity::CategoryTree::Node->new();
    isa_ok $p, 'Markets::Domain::Entity';

    can_ok $p, 'children';
    can_ok $p, 'level';
    can_ok $p, 'root_id';
    can_ok $p, 'title';
};

done_testing();
