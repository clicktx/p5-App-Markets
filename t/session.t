use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

# use Mojo::Cookie::Response;
my $cookie = Mojo::Cookie::Request->new( name => 'sid', value => 'bar', path => '/' );
my $tx = Mojo::Transaction::HTTP->new();
$tx->req->cookies($cookie);

my $session = Markets::Session->new(
    tx            => $tx,
    store         => Markets::Session::Store::Teng->new( db => $app->db ),
    transport     => MojoX::Session::Transport::Cookie->new,
    expires_delta => 3600,
);

# create session
my $sid = $session->create;
$session->flush;
ok $sid, 'created session';

# load session
$cookie = Mojo::Cookie::Request->new( name => 'sid', value => $sid, path => '/' );
$tx = Mojo::Transaction::HTTP->new();
$session->tx($tx);
$tx->req->cookies($cookie);
is $session->load, $sid, 'loading session';

# for cart session
my $cart = $session->cart;
is ref $cart, 'HASH', 'right cart';
my $cart_id = $session->cart_id;
ok $cart_id, 'right session->cart_id';

# set data
$session->data( counter => 1 );
$session->data( cart => { items => [] } );
$session->flush;
$session->load;
is $session->data('counter'), 1, 'right session value';
is_deeply $session->data('cart'), { items => [] }, 'right cart value';

# regenerate session
my %data    = %{ $session->data };
my $new_sid = $session->regenerate_sid;
isnt $sid, $new_sid, 'created new sid';
is $cart_id, $session->cart_id, 'don\'t create new cart_id';

my %new_data = %{ $session->data };
is %data, %new_data, 'right session data';

# remove session
$session->expire;
$session->flush;
is $session->load, undef, 'removed session';

done_testing();
