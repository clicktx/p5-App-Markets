use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Value::Expires';
use_ok $pkg;

subtest 'basic' => sub {
    my $v = $pkg->new();
    is $v->value, time + 600, 'right default construct';

    $v = $pkg->new(111);
    is $v->value, 111, 'right construct with arguments';
};

subtest 'is_expired' => sub {
    my $time    = time;
    my $expires = $time + 600;

    my $v = $pkg->new( value => $expires );
    is $v->is_expired, 0, 'right not expired';

    $expires = $time - 600;
    $v = $pkg->new( value => $expires );
    is $v->is_expired, 1, 'right expired';
};

done_testing();
