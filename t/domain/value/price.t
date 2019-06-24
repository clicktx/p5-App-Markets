use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg = 'Yetie::Domain::Value::Price';
use_ok $pkg;

subtest 'basic' => sub {
    dies_ok { $pkg->new( value => 0 ) } 'right dies';
    dies_ok { $pkg->new( value => -1 ) } 'right dies';
    lives_ok { $pkg->new( value => 1 ) } 'right lives';
    lives_ok { $pkg->new( value => 0.1 ) } 'right lives';
};

subtest 'sum' => sub {
    my $p  = $pkg->new(1);
    my $p2 = $p->sum(1);
    isnt $p, $p2, 'right different object';
    is $p->value,  1, 'right original';
    is $p2->value, 2, 'right sum';
};

done_testing();
