use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Address';

my $data = {
    id          => 1,
    line1       => '42 Pendergast St.',
    line2       => '',
    level1      => 'SC',
    level2      => 'Piedmont',
    postal_code => '29673',
};

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new( {} );
    isa_ok $address, 'Yetie::Domain::Entity';

    can_ok $address, 'line1';
    can_ok $address, 'line2';
    can_ok $address, 'level1';
    can_ok $address, 'level2';
};

subtest 'hash_code' => sub {
    my $address = Yetie::Domain::Entity::Address->new($data);
    is $address->hash_code, 'ddd317d966c94506903100cf3f48afee955127c4', 'right hash code';
};

done_testing();
