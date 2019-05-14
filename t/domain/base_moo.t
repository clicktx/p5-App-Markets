use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg = 'Yetie::Domain::BaseMoo';
use_ok $pkg;

subtest 'base' => sub {
    my $obj = $pkg->new;
    isa_ok $obj, $pkg;
    dies_ok { $pkg->new( foo => 1 ) } 'right do not have attribute';
};

done_testing();
