use Mojo::Base -strict;
use Test::More;
use Test::Exception;

my $pkg = 'Yetie::Domain::Base';
use_ok $pkg;

subtest 'base' => sub {
    throws_ok { $pkg->new( foo => 1 ) } qr/has not 'foo' attribute/, 'right do not have attribute';
};

done_testing();

# Strict
package Foo::Strict;
use Yetie::Domain::Base -strict;

# Role
package Foo::Role;
use Yetie::Domain::Base -role;

# Signatures
