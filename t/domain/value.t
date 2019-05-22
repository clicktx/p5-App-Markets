use Mojo::Base -strict;
use Test::More;
use Test::Exception;

{

    package t::domain::value;
    use Moose;
    extends 'Yetie::Domain::Value';

    has foo  => ( is => 'rw' );
    has bar  => ( is => 'rw' );
    has _foo => ( is => 'rw' );
    has _bar => ( is => 'rw' );
}

my $pkg = 'Yetie::Domain::Value';
use_ok $pkg;
my $test_pkg = 't::domain::value';
use_ok $test_pkg;

subtest 'basic' => sub {
    my $v;
    $v = $pkg->new( value => 'foo' );
    is $v->value, 'foo', 'right array arguments';

    $v = $pkg->new( { value => 'bar' } );
    is $v->value, 'bar', 'right hash refference argument';

    $v = $pkg->new();
    is $v->value, q{}, 'right not argument';
    $v = $pkg->new( value => undef );
    is $v->value, q{}, 'right argument undefined';
};

subtest '_dump_public_attr' => sub {
    my $obj = $test_pkg->new;
    is $obj->_dump_public_attr, q{bless( {}, 't::domain::value' )}, 'right dump strings';

    $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $obj->_dump_public_attr, q{bless( {'bar' => 2,'foo' => 1}, 't::domain::value' )}, 'right dump strings';
};

subtest '_hash_sum' => sub {
    my $obj      = $test_pkg->new;
    my $hash_sum = '565744a38263900bb971695a09a09799ce825f18';
    is $obj->_hash_sum, $hash_sum, 'right hash_sum';
    $obj->foo(1);
    is $obj->_hash_sum, $hash_sum, 'right modify attribute after call "_hash_sum"';

    $obj = $test_pkg->new;
    $obj->foo(1);
    is $obj->_hash_sum, $hash_sum, 'right modify attribute before call "_hash_sum"';
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
    my $hash_code = '957dcf386c1af5d3300c1f7d5095c71c8c019c8b';
    my $v = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $v->hash_code, $hash_code, 'right hash_code';
    $v = $test_pkg->new( foo => 1, bar => 2, _foo => 0, _bar => 0 );
    is $v->hash_code, $hash_code, 'right hash_code';
    $v = $test_pkg->new( foo => 0, bar => 2, _foo => 11, _bar => 22 );
    isnt $v->hash_code, $hash_code, 'right hash_code';
};

subtest 'is_modified' => sub {
    my $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $obj->is_modified, '0', 'right unmodified';
    $obj->_foo(111);
    is $obj->is_modified, '0', 'right modify private attribute';

    $obj->foo(3);
    is $obj->is_modified, 1, 'right modify public attribute';
};

subtest 'to_data' => sub {
    my $v = $pkg->new( value => 'foo' );
    is $v->to_data, 'foo', 'right to_data';
};

subtest 'immutable' => sub {
    my $v = $pkg->new( value => 'foo' );
    dies_ok { $v->value('bar') } 'right immutable';
};

done_testing();
