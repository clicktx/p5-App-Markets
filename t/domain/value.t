use Mojo::Base -strict;
use Test::More;
use Test::Exception;

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

subtest 'equals' => sub {
    my $v  = $test_pkg->new( value => 'foo',    foo => 1,   bar => 2 );
    my $v2 = $test_pkg->new( value => 'foo',    foo => 1,   bar => 2 );
    my $v3 = $test_pkg->new( value => 'foofoo', foo => 1,   bar => 2 );
    my $v4 = $test_pkg->new( value => 'foo',    foo => 111, bar => 2 );
    my $v5 = $test_pkg->new( value => 'foo',    foo => 1,   bar => 222 );
    my $v6 = $test_pkg->new( value => 'foo' );

    is $v->equals($v),  1, 'right equal';
    is $v->equals($v2), 1, 'right equal';
    is $v->equals($v3), 0, 'right not equal';
    is $v->equals($v4), 0, 'right not equal';
    is $v->equals($v5), 0, 'right not equal';
    is $v->equals($v6), 0, 'right not equal';
};

subtest 'hash_code' => sub {
    my $hash_code = '960167e90089e5ebe6a583e86b4c77507afb70b7';
    my $v = $test_pkg->new( value => 'foo', foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $v->hash_code, $hash_code, 'right hash_code';
    $v = $test_pkg->new( value => 'foo', foo => 1, bar => 2, _foo => 0, _bar => 0 );
    is $v->hash_code, $hash_code, 'right hash_code';
    $v = $test_pkg->new( value => 'foo', foo => 0, bar => 2, _foo => 11, _bar => 22 );
    isnt $v->hash_code, $hash_code, 'right hash_code';
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
