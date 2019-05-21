use Mojo::Base -strict;
use Test::More;
use Test::Exception;

{

    package t::domain::value;
    use Moose;
    extends 'Yetie::Domain::Value';

    has foo  => ( is => 'ro' );
    has bar  => ( is => 'ro' );
    has _foo => ( is => 'ro' );
    has _bar => ( is => 'ro' );
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

subtest 'to_data' => sub {
    my $v = $pkg->new( value => 'foo' );
    is $v->to_data, 'foo', 'right to_data';
};

subtest 'immutable' => sub {
    my $v = $pkg->new( value => 'foo' );
    dies_ok { $v->value('bar') } 'right immutable';
};

done_testing();
