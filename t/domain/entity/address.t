use Mojo::Base -strict;
use Test::More;

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

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new( {} );
    isa_ok $address, 'Yetie::Domain::Entity';
    can_ok $address, qw(
      country_code line1 line2 city state personal_name organization phone fax mobile
    );
    is $address->hash, 'da39a3ee5e6b4b0d3255bfef95601890afd80709', 'right hash';
};

subtest 'hash_code' => sub {
    my $address   = Yetie::Domain::Entity::Address->new($data);
    my $hash_code = $address->hash_code;
    is $hash_code, '915bbeaf59f081ea4aa03ccb7c9c7c4edef08e36', 'right hash code';

    $address->phone('222-3333');
    is $address->hash_code, $hash_code, 'right change phone';

    $address->personal_name('foo');
    isnt $address->hash_code, $hash_code, 'right change personal_name';

    $address->personal_name('ほげ');
    is $address->hash_code, 'b06e0458490e1dce77594138b31eabffc71944c8', 'right multibyte characters';
};

subtest 'field_names' => sub {
    my $address = Yetie::Domain::Entity::Address->new($data);
    isa_ok $address->field_names('no_country_code'), 'ARRAY', 'right field names';
};

subtest 'notation' => sub {
    my $address = Yetie::Domain::Entity::Address->new($data);
    isa_ok $address->notation('no_country_code'), 'ARRAY', 'right address notation';
};

subtest 'to_data' => sub {
    my $address = Yetie::Domain::Entity::Address->new($data);
    is_deeply $address->to_data,
      {
        hash          => '915bbeaf59f081ea4aa03ccb7c9c7c4edef08e36',
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
    is $address->to_data->{hash}, '915bbeaf59f081ea4aa03ccb7c9c7c4edef08e36', 'right rewrite hash';
};

done_testing();
