use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::TaxRule';

subtest 'basic' => sub {
    my $e = Yetie::Domain::Entity::TaxRule->new();
    isa_ok $e, 'Yetie::Domain::Entity';

    can_ok $e, 'tax_rate';
    can_ok $e, 'title';
};

done_testing();
