use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::CategoryTree';

subtest 'basic' => sub {
    my $p = Yetie::Domain::Entity::CategoryTree->new();
    isa_ok $p, 'Yetie::Domain::Entity';

    can_ok $p, 'children';
};

done_testing();
