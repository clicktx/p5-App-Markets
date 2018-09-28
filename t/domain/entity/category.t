use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Page::Category';

subtest 'basic' => sub {
    my $p = Yetie::Domain::Entity::Page::Category->new();
    isa_ok $p, 'Yetie::Domain::Entity::Page';

    can_ok $p, 'breadcrumbs';
    can_ok $p, 'products';
    can_ok $p, 'title';
};

done_testing();
