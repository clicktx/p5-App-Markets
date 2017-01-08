use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');

$t->get_ok('/product/1')->status_is(200)->content_like(qr/product/i);

done_testing();
