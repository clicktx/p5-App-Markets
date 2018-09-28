use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value';
use_ok $pkg;

subtest 'basic' => sub {
    my $v = $pkg->new();
    is $v->value, '', 'right not value';

    $v = $pkg->new( value => 'foo' );
    is $v->value, 'foo', 'right array arguments';

    $v = $pkg->new( { value => 'bar' } );
    is $v->value, 'bar', 'right hash refference argument';

    $v = $pkg->new('baz');
    is $v->value, 'baz', 'right scalar argument';
};

subtest 'operators' => sub {
    my $v = $pkg->new( value => 'foo' );
    ok !!$v;
    is "$v", 'foo', 'right stringify';
};

subtest 'to_data' => sub {
    my $v = $pkg->new( value => 'foo' );
    is $v->to_data, 'foo', 'right to_data';
};

subtest 'immutable' => sub {
    my $v = $pkg->new( value => 'foo' );
    eval { $v->value('bar') };
    like $@, qr/immutable/, 'right immutable';
};

done_testing();
