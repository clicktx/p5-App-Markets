use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Category';

subtest 'basic' => sub {
    my $p = Yetie::Domain::Entity::Category->new();
    isa_ok $p, 'Yetie::Domain::Entity';

    # can_ok $p, 'breadcrumbs';
    can_ok $p, 'products';
    can_ok $p, 'level';
    can_ok $p, 'root_id';
    can_ok $p, 'title';
};

done_testing();
