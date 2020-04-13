use Mojo::Base -strict;
use Test::More;
use Yetie::Factory;

use_ok 'Yetie::Domain::Entity::Address';

my $addrs = [
    [qw(id country_code state_id state_code line1 line2 city postal_code personal_name organization phone)],
    [ 1, 'US', '92', 'SC', '42 Pendergast St.', q{}, 'Piedmont', '29673', 'Claire Underwood', q{}, '0122345678' ],
    [
        2, 'US', '92', 'ＳＣ', '４２　　Ｐｅｎｄｅｒｇａｓｔ　Ｓｔ．',
        q{}, 'Ｐｉｅｄｍｏｎｔ', '２９６７３', 'Claire  Underwood',
        q{}, '０１２２３４５６７８'
    ],
];
my $cols = shift @{$addrs};
my $addr = shift @{$addrs};
my $data;
$data->{$_} = shift @{$addr} for @{$cols};

my $data_zenkaku;
$addr = shift @{$addrs};
$data_zenkaku->{$_} = shift @{$addr} for @{$cols};

sub construct {
    Yetie::Factory->new('entity-address')->construct(@_);
}

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new();
    isa_ok $address, 'Yetie::Domain::Entity';
    can_ok $address, qw(
      city country country_code hash line1 line2 organization
      personal_name phone postal_code state state_code state_id
    );
    is $address->hash, '790d1abdb65066c354f65d4292455ebd2ae7c479', 'right hash';
};

subtest 'equals' => sub {
    my $address1 = construct($data);
    my $address2 = construct($data);
    is $address1->equals($address2), 1, 'right equals';

    my $address3 = $address1->clone( personal_name => 'foo bar' );
    is $address1->equals($address3), 0, 'right not equals';
};

subtest 'field_names' => sub {
    my $address = construct($data);
    isa_ok $address->field_names('no_country_code'), 'ARRAY', 'right field names';
};

subtest 'hash_code' => sub {
    my $address   = construct($data);
    my $hash_code = $address->hash_code;
    is $hash_code, '2398f6c57bd11570dcae5e28461e535eaa46243f', 'right hash code';
    is $address->hash_code('empty'), '790d1abdb65066c354f65d4292455ebd2ae7c479', 'right empty hash code';

    my $address2 = $address->clone( personal_name => 'foo' );
    isnt $address2->hash_code, $hash_code, 'right change personal_name';

    my $address3 = $address->clone( personal_name => 'ほげ' );
    isnt $address3->hash_code, $hash_code, 'right multibyte characters';
};

subtest 'is_empty' => sub {
    my $address = construct();
    is $address->is_empty, 1, 'right data empty';

    my $address2 = $address->clone( country_code => 'US' );
    is $address2->is_empty, 0, 'right not empty';
};

subtest 'notation' => sub {
    my $address = construct($data);
    isa_ok $address->notation('no_country_code'), 'ARRAY', 'right address notation';
};

subtest 'to_data' => sub {
    my $address = construct($data);
    is_deeply $address->to_data,
      {
        id            => 1,
        hash          => '2398f6c57bd11570dcae5e28461e535eaa46243f',
        country_code  => 'US',
        state_id      => '92',
        line1         => '42 Pendergast St.',
        line2         => '',
        city          => 'Piedmont',
        postal_code   => '29673',
        personal_name => 'Claire Underwood',
        organization  => '',
        phone         => '0122345678',
      },
      'right dump data';
};

done_testing();
