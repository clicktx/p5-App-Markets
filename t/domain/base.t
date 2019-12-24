use Mojo::Base -strict;
use Test::More;
use Test::Exception;
use Mojo::Util qw/sha1_sum/;

{

    package t::domain::base;
    use Moose;
    extends 'Yetie::Domain::Base';

    has foo => (
        is     => 'ro',
        writer => 'set_foo',
    );
    has bar => (
        is     => 'ro',
        writer => 'set_bar',
    );
    has _foo => (
        is     => 'ro',
        writer => 'set__foo',
    );
    has _bar => (
        is     => 'ro',
        writer => 'set__bar',
    );

    package t::domain::p;
    use Moose;
    extends 'Yetie::Domain::Base';

    has v => (
        is      => 'ro',
        default => sub { t::domain::base->new },
    );

    package t::domain::i;
    use Moose;
    extends 'Yetie::Domain::Base';

    has t => (
        is     => 'ro',
        writer => 'set_t',
    );
    has c => (
        is      => 'ro',
        default => sub { t::domain::base->new },
    );
    has p => (
        is      => 'ro',
        default => sub { t::domain::p->new },
    );

}

my $pkg      = 'Yetie::Domain::Base';
my $test_pkg = 't::domain::base';
use_ok $pkg;
use_ok $test_pkg;

subtest 'base' => sub {
    my $obj = $pkg->new;
    isa_ok $obj, $pkg;
    dies_ok { $pkg->new( foo => 1 ) } 'right do not have attribute';

    dies_ok { $test_pkg->new( foo => [] ) } 'right arguments has array refference';
    dies_ok { $test_pkg->new( foo => {} ) } 'right arguments has hash refference';
};

subtest '_dump_by_public_attributes' => sub {
    my $obj = $test_pkg->new;
    is $obj->_dump_by_public_attributes, q{({bar=,foo=,},t::domain::base)}, 'right dump strings';

    $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $obj->_dump_by_public_attributes, q{({bar=2,foo=1,},t::domain::base)}, 'right dump strings';
};

subtest 'args_to_hash' => sub {
    my $e = $pkg->new();
    my %args = $e->args_to_hash( foo => 'bar' );
    is_deeply \%args, { foo => 'bar' }, 'right arguments hash';
    %args = $e->args_to_hash( { foo => 'bar' } );
    is_deeply \%args, { foo => 'bar' }, 'right arguments hash reference';
};

subtest 'args_to_hashref' => sub {
    my $e = $pkg->new();
    my $args = $e->args_to_hashref( foo => 'bar' );
    is_deeply $args, { foo => 'bar' }, 'right arguments hash';
    $args = $e->args_to_hashref( { foo => 'bar' } );
    is_deeply $args, { foo => 'bar' }, 'right arguments hash reference';
};

subtest 'factory' => sub {
    my $e = $pkg->new();
    my $f = $pkg->factory('entity-foo');
    isa_ok $f, 'Yetie::Factory';
};

subtest 'get_all_attribute_names' => sub {
    my $obj   = $test_pkg->new;
    my @names = $obj->get_all_attribute_names;
    is_deeply \@names, [qw{_bar _foo _hash_sum bar foo}], 'right not arguments';

    $obj = $test_pkg->new( foo => 1, bar => 2 );
    @names = $obj->get_all_attribute_names;
    is_deeply \@names, [qw{_bar _foo _hash_sum bar foo}], 'right arguments';
};

subtest 'get_public_attribute_names' => sub {
    my $obj   = $test_pkg->new;
    my @names = $obj->get_public_attribute_names;
    is_deeply \@names, [qw{bar foo}], 'right not arguments';

    $obj = $test_pkg->new( foo => 1, bar => 2 );
    @names = $obj->get_public_attribute_names;
    is_deeply \@names, [qw{bar foo}], 'right arguments';
};

subtest 'hash_code' => sub {
    my $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 1, _bar => 2 );
    is $obj->hash_code, '53f602b47678003afdc84ef70de8e93cae740477', 'right hash code';
    $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 111, _bar => 2222 );
    is $obj->hash_code, '53f602b47678003afdc84ef70de8e93cae740477', 'right hash code';
    $obj = $test_pkg->new( foo => 0, bar => 2, _foo => 1, _bar => 2 );
    isnt $obj->hash_code, '53f602b47678003afdc84ef70de8e93cae740477', 'right hash code';

    is $obj->hash_code(2), sha1_sum(2), 'right create hash code';
};

subtest 'rehash' => sub {
    my $obj = $test_pkg->new( foo => 1 );
    my $hash_sum = $obj->hash_sum;
    $obj->set_foo(2);
    is $hash_sum, $obj->hash_sum, 'right hash_sum';
    $obj->rehash;
    isnt $hash_sum, $obj->hash_sum, 'right rehash';

    $hash_sum = $obj->hash_sum;
    my $obj2 = $test_pkg->new( bar => $obj );
    $obj2->bar->_set_hash_sum('foo');
    $obj2->rehash;
    is $hash_sum, $obj2->bar->hash_sum, 'right recursive rehash';
};

subtest 'set_attributes' => sub {
    my $obj = $test_pkg->new();
    $obj->set_attributes(
        {
            foo  => 1,
            bar  => 2,
            _foo => 3,
            _bar => 4,
        }
    );
    is $obj->foo,  1, 'right attr';
    is $obj->bar,  2, 'right attr';
    is $obj->_foo, 3, 'right attr';
    is $obj->_bar, 4, 'right attr';

    $obj = t::domain::i->new();
    $obj->set_attributes(
        {
            t => 'title',
            c => {
                foo => 'category',
            },
            p => {
                v => { foo => 'price' },
            },
        }
    );
    is $obj->t, 'title', 'right attr';
    is $obj->c->foo, 'category', 'right attr';
    is $obj->p->v->foo, 'price', 'right attr';
};

done_testing();
