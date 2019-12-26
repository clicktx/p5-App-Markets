use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Util';

subtest 'args2hash' => sub {

    package t::argument;
    use Yetie::Util qw(args2hash);
    use Test::More;
    my %args = args2hash(qw[foo 1 bar 2 baz 3]);
    is_deeply \%args, { foo => 1, bar => 2, baz => 3 }, 'right return hash';
    my $args = args2hash(qw[foo 1 bar 2 baz 3]);
    is_deeply $args, { foo => 1, bar => 2, baz => 3 }, 'right return hash reference';
};

subtest 'array_to_hash' => sub {
    my @array = (qw/a b c/);

    my %hash = Yetie::Util::array_to_hash(@array);
    is_deeply \%hash, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash';
    %hash = Yetie::Util::array_to_hash('a');
    is_deeply \%hash, { 0 => 'a' }, 'right convert to hash(single argument)';
    %hash = Yetie::Util::array_to_hash();
    is_deeply \%hash, {}, 'right convert to hash(no argument)';

    my $hashref = Yetie::Util::array_to_hash(@array);
    is_deeply $hashref, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash reference';

    %hash = Yetie::Util::array_to_hash( \@array );
    is_deeply \%hash, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash(arguments array reference)';

    $hashref = Yetie::Util::array_to_hash( \@array );
    is_deeply $hashref, { 0 => 'a', 1 => 'b', 2 => 'c' }, 'right convert to hash reference(arguments array reference)';
};

subtest 'directories' => sub {
    my $themes = Yetie::Util::directories( 'themes', { ignore => [ 'admin', 'common', 'default' ] } );
    is_deeply $themes, ['mytheme'], 'loading mytheme';

    my $addons = Yetie::Util::directories('addons');
    is ref $addons, 'ARRAY', 'loading addons';
};

subtest 'hashids' => sub {
    my $h = Yetie::Util::hashids();
    isa_ok $h, 'Hashids';

    my $id = $h->encode(12345);
    is $id , 'JWYWZ4', 'right encode';
    is $h->decode($id), 12345, 'right decode';

    my $id2 = Yetie::Util::hashids('EEB37B41-3DED-40EC-A058-19FA4F4F98D1')->encode(12345);
    isnt $id, $id2, 'right use salt';
};

subtest 'uuid' => sub {
    my $uuid = Yetie::Util::uuid();
    my $r    = qr/[0-9A-F]/;
    like $uuid, qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right UUID';
};

done_testing();
