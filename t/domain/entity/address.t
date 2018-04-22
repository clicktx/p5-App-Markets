use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Address';

my $data = {
    id            => 1,
    line1         => '42 Pendergast St.',
    line2         => '',
    level1        => 'SC',
    level2        => 'Piedmont',
    postal_code   => '29673',
    personal_name => 'Claire Underwood',
    company_name  => '',
    phone         => '123-4567',
    fax           => '',
    mobile        => '',
};

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new( {} );
    isa_ok $address, 'Yetie::Domain::Entity';

    can_ok $address, 'line1';
    can_ok $address, 'line2';
    can_ok $address, 'level1';
    can_ok $address, 'level2';
    can_ok $address, 'personal_name';
    can_ok $address, 'company_name';
    can_ok $address, 'phone';
    can_ok $address, 'fax';
    can_ok $address, 'mobile';
};

subtest 'hash_code' => sub {
    my $address   = Yetie::Domain::Entity::Address->new($data);
    my $hash_code = $address->hash_code;
    is $hash_code, 'ce13c4019b768f9b52cef27d3cd1d4ec5ef0d63f', 'right hash code';

    $address->phone('222-3333');
    is $address->hash_code, $hash_code, 'right change phone';

    $address->personal_name('foo');
    isnt $address->hash_code, $hash_code, 'right change personal_name';
};

done_testing();
