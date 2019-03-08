use Mojo::Base -strict;
use Test::More;
use Test::Deep;
use Test::Exception;
use Yetie::Factory;

use_ok 'Yetie::Domain::Set::Preferences';

subtest 'default attributes' => sub {
    my $p = Yetie::Domain::Set::Preferences->new;
    isa_ok $p->hash_set, 'Yetie::Domain::IxHash', 'right properties';
};

my $data = {
    hash_set => [
        {
            hoge => {
                id            => 3,
                value         => '',
                default_value => '33',
                position      => 100,
                group_id      => 2,
            }
        },
        {
            fuga => {
                id            => 4,
                value         => '',
                default_value => '44',
                position      => 200,
                group_id      => 1,
            }
        },
        {
            pref2 => {
                id            => 2,
                value         => '',
                default_value => '22',
                position      => 300,
                group_id      => 2,
            }
        },
        {
            pref1 => {
                id            => 1,
                value         => '',
                default_value => '11',
                position      => 500,
                group_id      => 1,
            }
        },
    ]
};

my $construct = sub { Yetie::Factory->new('set-preferences')->construct($data) };

subtest 'basic' => sub {
    my $pref = $construct->();
    isa_ok $pref, 'Yetie::Domain::Set';
};

subtest 'properties' => sub {
    my $pref = $construct->();
    can_ok $pref, 'properties';
    isa_ok $pref->properties, 'Yetie::Domain::IxHash';

    $pref->properties(undef);
    is $pref->properties, undef, 'right set properties';
};

subtest 'value' => sub {
    my $pref = $construct->();
    can_ok $pref, 'value';

    is $pref->value('pref1'), 11, 'right default value';
    $pref->value( pref1 => 1, pref2 => 2 );
    is $pref->value('pref1'), 1, 'right set value';
    is $pref->value('pref2'), 2, 'right set value';
    is $pref->is_modified, 1, 'right modified';

    dies_ok { $pref->value( pref3 => 3 ) } 'right set value error';
    dies_ok { $pref->value('pref3') } 'right get value error';
};

done_testing();
