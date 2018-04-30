use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Entity::Address';

my $addrs = [
    [qw(id line1 line2 level1 level2 postal_code personal_name company_name phone fax mobile)],
    [ 1, '42 Pendergast St.', '', 'SC', 'Piedmont', '29673', 'Claire Underwood', '', '123-4567', '', '' ],
];
my $cols = shift @{$addrs};
my $addr = shift @{$addrs};
my $data;
$data->{$_} = shift @{$addr} for @{$cols};

subtest 'basic' => sub {
    my $address = Yetie::Domain::Entity::Address->new( {} );
    isa_ok $address, 'Yetie::Domain::Entity';

    can_ok $address, qw(
      line1 line2 level1 level2 personal_name company_name phone fax mobile
    );
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

subtest 'fields' => sub {
    my $address = Yetie::Domain::Entity::Address->new($data);
    isa_ok $address->fields('no_country_code'), 'ARRAY', 'right not found country';
};

done_testing();
