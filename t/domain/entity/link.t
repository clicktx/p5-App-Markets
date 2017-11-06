use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Link';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::Link->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'title';
    can_ok $e, 'url';
};

done_testing();
