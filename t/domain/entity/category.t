use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Category';

subtest 'basic' => sub {
    my $p = Markets::Domain::Entity::Category->new();
    isa_ok $p, 'Markets::Domain::Entity';

    can_ok $p, 'title';
    can_ok $p, 'level';
    can_ok $p, 'root_id';
};

done_testing();
