use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::Factory;

use_ok 'Yetie::Domain::Entity::Address';

my $addrs = [
    [qw(id country_code line1 line2 city state postal_code personal_name organization phone fax mobile)],
    [ 1, 'us', '42 Pendergast St.', '', 'Piedmont', 'SC', '29673', 'Claire Underwood', '', '(012)234-5678', '', '' ],
    [
        2, 'us', '４２　　Ｐｅｎｄｅｒｇａｓｔ　Ｓｔ．',
        '', 'Ｐｉｅｄｍｏｎｔ', 'ＳＣ', '２９６７３', 'Claire  Underwood',
        '', '（０１２）２３４ー５６７８',
        '', ''
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
      type hash country_code line1 line2 city state personal_name organization phone fax mobile
    );
    is $address->hash, 'cd4f81b52fc788ff8b2e226926eab5f7e87e99ec', 'right hash';
};

subtest 'hash_code' => sub {
    my $address   = _create_entity();
    my $hash_code = $address->hash_code;
    is $hash_code, '4011e7354a7e966e79c953465534760729e84cca', 'right hash code';

    $address->personal_name('foo');
    isnt $address->hash_code, $hash_code, 'right change personal_name';

    $address->personal_name('ほげ');
    is $address->hash_code, '5534cdcdcc9041b356839bea89f9aaae3b5f8179', 'right multibyte characters';
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
        hash          => '4011e7354a7e966e79c953465534760729e84cca',
        country_code  => 'us',
        line1         => '42 Pendergast St.',
        line2         => '',
        city          => 'Piedmont',
        state         => 'SC',
        postal_code   => '29673',
        personal_name => 'Claire Underwood',
        organization  => '',
        phone         => '(012)234-5678',
        fax           => '',
        mobile        => '',
      },
      'right dump data';

    $address->hash('foobar');
    is $address->to_data->{hash}, '4011e7354a7e966e79c953465534760729e84cca', 'right rewrite hash';
};

done_testing();
