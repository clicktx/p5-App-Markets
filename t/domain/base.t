use Mojo::Base -strict;
use Test::More;
use Test::Exception;
use Mojo::Util qw/sha1_sum/;

{

    package t::domain::base;
    use Moose;
    extends 'Yetie::Domain::Base';

    has [qw{foo bar _foo _bar}] => ( is => 'rw' );
}

my $pkg      = 'Yetie::Domain::Base';
my $test_pkg = 't::domain::base';
use_ok $pkg;
use_ok $test_pkg;

subtest 'base' => sub {
    my $obj = $pkg->new;
    isa_ok $obj, $pkg;
    dies_ok { $pkg->new( foo => 1 ) } 'right do not have attribute';
};

subtest '_dump_by_public_attributes' => sub {
    my $obj = $test_pkg->new;
    is $obj->_dump_by_public_attributes, q{({bar=,foo=,},t::domain::base)}, 'right dump strings';

    $obj = $test_pkg->new( foo => 1, bar => 2, _foo => 11, _bar => 22 );
    is $obj->_dump_by_public_attributes, q{({bar=2,foo=1,},t::domain::base)}, 'right dump strings';
};

subtest 'get_all_attribute_names' => sub {
    my $obj   = $test_pkg->new;
    my @names = $obj->get_all_attribute_names;
    is_deeply \@names, [qw{_bar _foo bar foo}], 'right not arguments';

    $obj = $test_pkg->new( foo => 1, bar => 2 );
    @names = $obj->get_all_attribute_names;
    is_deeply \@names, [qw{_bar _foo bar foo}], 'right arguments';
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

done_testing();
