use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::CategoryTree';

subtest 'basic' => sub {
    my $p = Markets::Domain::Entity::CategoryTree->new();
    isa_ok $p, 'Markets::Domain::Entity';

    can_ok $p, 'children';
};

done_testing();
