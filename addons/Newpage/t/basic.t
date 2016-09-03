use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('Markets');
my $app = $t->app;

subtest 'access check' => sub {
    $t->get_ok('/newpage')->status_is(200);
    $t->get_ok('/newpage/page')->status_is(200);
};

done_testing();
