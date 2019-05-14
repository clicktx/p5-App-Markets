use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg = 'Yetie::Domain::BaseMoo';
use_ok $pkg;

subtest 'base' => sub {
    throws_ok { $pkg->new( foo => 1 ) } qr/has not 'foo' attribute/, 'right do not have attribute';
};

done_testing();
