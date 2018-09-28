use Mojo::Base -strict;
use Test::More;

my $pkg = 'Yetie::Domain::Base';
use_ok $pkg;

subtest 'base' => sub {
    eval { $pkg->new( foo => 1 ) };
    like $@, qr/has not 'foo' attribute/, '';
};

done_testing();

# Strict
package Foo::Strict;
use Yetie::Domain::Base -strict;

# Role
package Foo::Role;
use Yetie::Domain::Base -role;

# Signatures
