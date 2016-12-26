use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t = Test::Mojo->new('App');

subtest 'CSRF check' => sub {
    $t->get_ok('/account/login');
    my $tx         = $t->tx;
    my $csrf_token = $tx->res->dom->at('input[name="csrf_token"]')->{value};

    say "t::security: csrf_token=" . $csrf_token;

    $t->post_ok( '/account/authenticate', form => { csrf_token => 'dummy' } )->status_is(403)
      ->content_like(qr/csrf/i);
    $t->post_ok( '/account/authenticate', form => { csrf_token => $csrf_token } )->status_is(302);
};

done_testing();
