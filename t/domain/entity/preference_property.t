use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::PreferenceProperty';

subtest 'default attributes' => sub {
    my $o = Yetie::Domain::Entity::PreferenceProperty->new();

    isa_ok $o, 'Yetie::Domain::MooseEntity', 'right customer';

    can_ok $o, 'name';
    can_ok $o, 'value';
    can_ok $o, 'default_value';
    can_ok $o, 'title';
    can_ok $o, 'summary';
    can_ok $o, 'position';
    can_ok $o, 'group_id';
};

done_testing();
