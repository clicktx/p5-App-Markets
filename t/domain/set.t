use Mojo::Base -strict;
use Test::More;
use Yetie::Domain::IxHash qw(ixhash);

my $pkg = 'Yetie::Domain::Set';
use_ok $pkg;

my $construct = sub {
    my $hash_set = ixhash(@_);
    $pkg->new( hash_set => $hash_set );
};

subtest 'basic' => sub {
    my $set = $construct->();
    isa_ok $set->hash_set, 'Yetie::Domain::IxHash', 'right attribute hash_set';
    can_ok $set, 'each';
};

subtest 'get' => sub {
    my $set = $construct->( foo => 1, bar => 2, baz => 3 );
    is $set->get('bar'), 2,     'right get element';
    is $set->get('qux'), undef, 'right has not element';
};

subtest 'has_elements' => sub {
    my $set = $construct->();
    ok !$set->has_elements, 'right not has elements';

    $set = $construct->( foo => 1, bar => 2, baz => 3 );
    ok $set->has_elements, 'right has elements';
};

subtest 'to_data' => sub {
    my $set = $construct->( foo => 1, bar => 2, baz => 3 );
    is_deeply $set->to_data, { foo => 1, bar => 2, baz => 3 }, 'right dump data';
};

done_testing();
