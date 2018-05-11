use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Address';

my $addrs = [
    [qw(id country_code line1 line2 level1 level2 postal_code personal_name company_name phone fax mobile)],
    [ 1, 'us', '42 Pendergast St.', '', 'SC', 'Piedmont', '29673', 'Claire Underwood', '', '123-4567', '', '' ],
];
my $cols = shift @{$addrs};
my $addr = shift @{$addrs};
my $data;
$data->{$_} = shift @{$addr} for @{$cols};

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new( {} );
    isa_ok $address, 'Yetie::Domain::Entity';

    can_ok $address, qw(
      country_code line1 line2 level1 level2 personal_name company_name phone fax mobile
    );
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

done_testing();
