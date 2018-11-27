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
};

subtest 'operators' => sub {
    my $v = $pkg->new( value => 'foo' );
    ok !!$v;
    is "$v", 'foo', 'right stringify';
};

subtest 'equal' => sub {
    my $v  = $pkg->new( value => 'foo' );
    my $v2 = $pkg->new( value => 'foo' );
    is $v->equal($v2), 1, 'right object';
    is $v->equal('foo'), 1, 'right string';

    my $v3 = $pkg->new( value => 'bar' );
    is $v->equal($v3), 0, 'right object';
    is $v->equal('bar'), 0, 'right string';
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
