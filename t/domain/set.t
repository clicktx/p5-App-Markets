use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Set';
use_ok $pkg;

subtest 'basic' => sub {
    my $v = $pkg->new();
    isa_ok $v->hash_set, 'Yetie::Domain::IxHash', 'right attribute hash_set';
    can_ok $v, 'each';
};

done_testing();
