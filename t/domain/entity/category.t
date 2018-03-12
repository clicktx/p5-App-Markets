use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Category';

subtest 'basic' => sub {
    my $p = Yetie::Domain::Entity::Category->new();
    isa_ok $p, 'Yetie::Domain::Entity';

    can_ok $p, 'breadcrumb';
    can_ok $p, 'products';
    can_ok $p, 'title';
};

done_testing();
