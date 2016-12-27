use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;
use Data::Dumper;

my $t = Test::Mojo->new('App');

subtest 'Access' => sub {
    $t->get_ok('/account/login');
    my $tx         = $t->tx;
    my $csrf_token = $tx->res->dom->at('input[name="csrf_token"]')->{value};
    say "t::security: csrf_token=" . $csrf_token;
    $t->post_ok( '/account/login',
        form => { csrf_token => $csrf_token, customer_id => 'default', password => 'pass' } )
      ->status_is(302);

    $t->get_ok('/account/home')->status_is(200);
    $t->get_ok('/account/logout')->status_is(200);
};

done_testing();
