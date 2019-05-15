use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg      = 'Yetie::Domain::BaseMoo';
my $test_pkg = 't::domain::base';
use_ok $pkg;
use_ok $test_pkg;

subtest 'base' => sub {
    my $obj = $pkg->new;
    isa_ok $obj, $pkg;
    dies_ok { $pkg->new( foo => 1 ) } 'right do not have attribute';
};

subtest 'dump' => sub {
    my $obj = $test_pkg->new;
    is $obj->dump, q{bless( {}, 't::domain::base' )}, 'right dump strings';

    $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $obj->dump, q{bless( {'bar' => 2,'foo' => 1}, 't::domain::base' )}, 'right dump strings';

};

subtest 'equals' => sub {
    my $v  = $test_pkg->new( foo => 1,   bar => 2 );
    my $v2 = $test_pkg->new( foo => 1,   bar => 2 );
    my $v3 = $test_pkg->new( foo => 1,   bar => 2, _foo => 1, _bar => 2 );
    my $v4 = $test_pkg->new( foo => 111, bar => 2 );
    my $v5 = $test_pkg->new( foo => 1,   bar => 222 );
    my $v6 = $test_pkg->new();

    is $v->equals($v),  1, 'right equal';
    is $v->equals($v2), 1, 'right equal';
    is $v->equals($v3), 1, 'right equal';
    is $v->equals($v4), 0, 'right not equal';
    is $v->equals($v5), 0, 'right not equal';
    is $v->equals($v6), 0, 'right not equal';
};

subtest 'hash_code' => sub {
    my $hash_code = 'db18e17f06b3fbd43916234e598060f203bb734e';
    my $v = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $v->hash_code, $hash_code, 'right hash_code';
    $v = $test_pkg->new( foo => 1, bar => 2, _foo => 0, _bar => 0 );
    is $v->hash_code, $hash_code, 'right hash_code';
    $v = $test_pkg->new( foo => 0, bar => 2, _foo => 11, _bar => 22 );
    isnt $v->hash_code, $hash_code, 'right hash_code';
};

done_testing();
