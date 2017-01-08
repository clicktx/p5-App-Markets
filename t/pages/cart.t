use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('App');

$t->get_ok('/cart')->status_is(200)->content_like(qr/cart/i);

done_testing();
