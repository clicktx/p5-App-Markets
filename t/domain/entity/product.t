use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Entity::Product';

subtest 'basic' => sub {
    my $p = Markets::Domain::Entity::Product->new();
    isa_ok $p, 'Markets::Domain::Entity';

    can_ok $p, 'title';
    can_ok $p, 'description';
    can_ok $p, 'price';
};

done_testing();
