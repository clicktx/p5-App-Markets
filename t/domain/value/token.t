use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value::Token';
use_ok $pkg;

subtest 'basic' => sub {
    my $v  = $pkg->new;
    my $v2 = $pkg->new;
    my $r  = qr/[0-9A-F]/;
    like $v->value, qr/$r{8}\-$r{4}\-4$r{3}\-[89AB]$r{3}\-$r{12}/, 'right create value';
    isnt $v->value, $v2->value, 'right default value';

    $v = $pkg->new( value => 'foobar' );
    is $v->value, 'foobar', 'right set attributes';
};

done_testing();
