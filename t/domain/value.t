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

    $v = $pkg->new('foo');
    is $v->value, 'foo', 'right single argument';
};

subtest '_hash_sum' => sub {
    my $obj      = $test_pkg->new;
    my $hash_sum = '4d307fef71be148cb0768c96b17b64455d0347a9';
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

subtest 'clone' => sub {
    my $obj = $test_pkg->new( value => 'foo', foo => 1, bar => 2, _foo => 11, _bar => 22 );
    my $clone = $obj->clone;
    ok $obj->equals($clone), 'right equals object';
    isnt $obj, $clone, 'right different object';

    $obj->foo(2);
    ok !$clone->is_modified, 'right not modified';

    $clone = $obj->clone;
    ok !$clone->is_modified, 'right not modified';
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

subtest 'set_value' => sub {
    my $v = $pkg->new( value => 'foo' );
    my $new = $v->set_value('foo');
    isnt $v, $new, 'right different object';
    ok $v->equals($new), 'right equals';

    $new = $v->set_value('bar');
    ok !$v->equals($new), 'right not equals';
};

subtest 'immutable' => sub {
    my $v = $pkg->new( value => 'foo' );
    dies_ok { $v->value('bar') } 'right immutable';
};

done_testing();
