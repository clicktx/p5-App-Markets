use Mojo::Base -strict;
use Test::More;
use Test::Exception;

{

    package t::domain::base;
    use Moose;
    extends 'Yetie::Domain::MooseBase';

    has [qw{foo bar _foo _bar}] => ( is => 'rw' );
}

my $pkg      = 'Yetie::Domain::MooseBase';
my $test_pkg = 't::domain::base';
use_ok $pkg;
use_ok $test_pkg;

subtest 'base' => sub {
    my $obj = $pkg->new;
    isa_ok $obj, $pkg;
    dies_ok { $pkg->new( foo => 1 ) } 'right do not have attribute';
};

subtest '_hash_sum' => sub {
    my $obj      = $test_pkg->new;
    my $hash_sum = 'e3274511720b789b54e8e68c1506a97fd3645cac';
    is $obj->_hash_sum, $hash_sum, 'right hash_sum';
    $obj->foo(1);
    is $obj->_hash_sum, $hash_sum, 'right modify attribute after call "_hash_sum"';

    $obj = $test_pkg->new;
    $obj->foo(1);
    is $obj->_hash_sum, $hash_sum, 'right modify attribute before call "_hash_sum"';
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

subtest 'is_modified' => sub {

    my $obj = t::domain::base->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $obj->is_modified, '0', 'right unmodified';
    $obj->_foo(111);
    is $obj->is_modified, '0', 'right modify private attribute';

    $obj->foo(3);
    is $obj->is_modified, 1, 'right modify public attribute';
};

done_testing();
