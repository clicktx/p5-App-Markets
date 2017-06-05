use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;
use t::Util;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Markets::Domain::Entity::Preference';

my $data = {
    items => {
        pref1 => {
            id            => 1,
            name          => 'pref1',
            value         => '',
            default_value => '11',
            summary       => '',
            position      => 500,
            group_id      => 1,
        },
        pref2 => {
            id            => 2,
            name          => 'pref2',
            value         => '',
            default_value => '22',
            summary       => '',
            position      => 100,
            group_id      => 1,
        },
    },
};

my $pref = $app->factory('entity-preference')->create($data);

subtest 'basic' => sub {
    isa_ok $pref, 'Markets::Domain::Entity';
};

subtest 'attributes' => sub {
    can_ok $pref, 'items';
};

subtest 'methods' => sub {
    can_ok $pref, 'value';

    # value()
    is $pref->value('pref1'), 11;    # default value
    $pref->value( pref1 => 1 );
    is $pref->value('pref1'), 1;
    is $pref->is_modified, 1;
};

done_testing();
