use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Breadcrumb';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::Breadcrumb->new();
    isa_ok $e, 'Yetie::Domain::MooseEntity';

    can_ok $e, 'class';
    can_ok $e, 'title';
    isa_ok $e->url, 'Mojo::URL';
};

done_testing();
