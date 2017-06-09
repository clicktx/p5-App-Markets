use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Mojo;
use t::Util;
use Tie::IxHash;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

use_ok 'Markets::Domain::Entity::Preference';

# NOTE: position昇順になっている
my %items;
tie %items, 'Tie::IxHash';
%items = (
    hoge => {
        id            => 3,
        value         => '',
        default_value => '33',
        position      => 100,
        group_id      => 2,
    },
    fuga => {
        id            => 4,
        value         => '',
        default_value => '44',
        position      => 200,
        group_id      => 1,
    },
    pref2 => {
        id            => 2,
        value         => '',
        default_value => '22',
        position      => 300,
        group_id      => 2,
    },
    pref1 => {
        id            => 1,
        value         => '',
        default_value => '11',
        position      => 500,
        group_id      => 1,
    },
);

my $pref = $app->factory('entity-preference')->create( { items => \%items } );

subtest 'basic' => sub {
    isa_ok $pref, 'Markets::Domain::Entity';
};

subtest 'attributes' => sub {
    can_ok $pref, 'items';
};

subtest 'value()' => sub {
    can_ok $pref, 'value';

    is $pref->value('pref1'), 11, 'right default value';
    $pref->value( pref1 => 1, pref2 => 2 );
    is $pref->value('pref1'), 1, 'right set value';
    is $pref->value('pref2'), 2, 'right set value';
    is $pref->is_modified, 1, 'right modified';

    eval { $pref->value( pref3 => 3 ) };
    ok $@, 'right set value error';
    eval { $pref->value('pref3') };
    ok $@, 'right get value error';
};

done_testing();
