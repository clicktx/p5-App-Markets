use Mojo::Base -strict;
use Test::More;
use Test::Exception;

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

done_testing();
