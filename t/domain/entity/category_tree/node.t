use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::CategoryTree::Node';

subtest 'basic' => sub {
    my $p = Yetie::Domain::Entity::CategoryTree::Node->new();
    isa_ok $p, 'Yetie::Domain::Entity';

    can_ok $p, 'children';
    can_ok $p, 'level';
    can_ok $p, 'root_id';
    can_ok $p, 'title';
};

done_testing();
