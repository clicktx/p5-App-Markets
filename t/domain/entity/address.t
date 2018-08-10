use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

use_ok 'Yetie::Domain::Entity::Address';

my $addrs = [
    [qw(id country_code line1 line2 city state postal_code personal_name organization phone)],
    [ 1, 'us', '42 Pendergast St.', '', 'Piedmont', 'SC', '29673', 'Claire Underwood', '', '0122345678' ],
    [
        2, 'us', '４２　　Ｐｅｎｄｅｒｇａｓｔ　Ｓｔ．',
        '', 'Ｐｉｅｄｍｏｎｔ', 'ＳＣ', '２９６７３', 'Claire  Underwood',
        '', '０１２２３４５６７８'
    ],
];
my $cols = shift @{$addrs};
my $addr = shift @{$addrs};
my $data;
$data->{$_} = shift @{$addr} for @{$cols};

my $data_zenkaku;
$addr = shift @{$addrs};
$data_zenkaku->{$_} = shift @{$addr} for @{$cols};

sub _create_entity {
    Yetie::Domain::Factory->new('entity-address')->create($data);
}

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new( {} );
    isa_ok $address, 'Yetie::Domain::Entity';
    can_ok $address, qw(
      type hash country_code line1 line2 city state personal_name organization phone
    );
    is $address->hash, '20f551adf8c892c32845022b874e0763ecf68788', 'right hash';
};

subtest 'hash_code' => sub {
    my $address   = _create_entity();
    my $hash_code = $address->hash_code;
    is $hash_code, '83fdfb97f5ec0b93d486606da8a032af87235ccc', 'right hash code';

    $address->personal_name('foo');
    isnt $address->hash_code, $hash_code, 'right change personal_name';

    $address->personal_name('ほげ');
    is $address->hash_code, '29f476a4d05499095ff5ed2ec45e86951683951a', 'right multibyte characters';
};

subtest 'field_names' => sub {
    my $address = _create_entity();
    isa_ok $address->field_names('no_country_code'), 'ARRAY', 'right field names';
};

subtest 'notation' => sub {
    my $address = _create_entity();
    isa_ok $address->notation('no_country_code'), 'ARRAY', 'right address notation';
};

subtest 'to_data' => sub {
    my $address = _create_entity();
    is_deeply $address->to_data,
      {
        hash          => '83fdfb97f5ec0b93d486606da8a032af87235ccc',
        country_code  => 'us',
        line1         => '42 Pendergast St.',
        line2         => '',
        city          => 'Piedmont',
        state         => 'SC',
        postal_code   => '29673',
        personal_name => 'Claire Underwood',
        organization  => '',
        phone         => '0122345678',
      },
      'right dump data';

    $address->hash('foobar');
    is $address->to_data->{hash}, '83fdfb97f5ec0b93d486606da8a032af87235ccc', 'right rewrite hash';
};

done_testing();
