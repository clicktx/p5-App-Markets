use Mojo::Base -strict;
use Test::More;

use_ok 'Yetie::Domain::Base';

# new
eval { Yetie::Domain::Base->new( foo => 1 ) };
like $@, qr/has not 'foo' attribute/, '';

# Role

# Signatures

done_testing();
