use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::IxHash qw(ix_hash);

my $pkg = 'Yetie::Domain::Set';
use_ok $pkg;

my $construct = sub {
    my $hash_set = ix_hash(@_);
    $pkg->new( hash_set => $hash_set );
};

subtest 'basic' => sub {
    my $v = $construct->();
    isa_ok $v->hash_set, 'Yetie::Domain::IxHash', 'right attribute hash_set';
    can_ok $v, 'each';
};

subtest 'get' => sub {
    my $v = $construct->( foo => 1, bar => 2, baz => 3 );
    is $v->get('bar'), 2,     'right get element';
    is $v->get('qux'), undef, 'right has not element';
};

subtest 'to_data' => sub {
    my $v = $construct->( foo => 1, bar => 2, baz => 3 );
    is_deeply $v->to_data, { foo => 1, bar => 2, baz => 3 }, 'right dump data';
};

done_testing();
