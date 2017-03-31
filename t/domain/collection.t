use Mojo::Base -strict;
use Test::More;

use_ok 'Markets::Domain::Collection';

subtest 'basic' => sub {
    isa_ok Markets::Domain::Collection->new(), 'Markets::Domain::Collection';
};

done_testing();
