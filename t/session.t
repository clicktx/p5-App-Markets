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

my $session = Markets::Session::ServerSession->new(
    tx            => $tx,
    store         => Markets::Session::Store::Dbic->new( schema => $app->db ),
    transport     => MojoX::Session::Transport::Cookie->new,
    expires_delta => 3600,
);

# create session
my $sid = $session->create;
ok $sid, 'created session';
is_deeply $session->cart_session->data, {}, 'create new cart';

$session->flush;
is_deeply $session->cart_session->data, {}, 'cart data after flush';

my $cart_id = $session->cart_id;
ok $cart_id, 'right session->cart_id';

# load session
$cookie = Mojo::Cookie::Request->new( name => 'sid', value => $sid, path => '/' );
$tx = Mojo::Transaction::HTTP->new();
$session->tx($tx);
$tx->req->cookies($cookie);
is $session->load, $sid, 'loading session';
is ref $session->cart_session->data, 'HASH', 'right cart data';
is $session->cart_session->cart_id, $cart_id, 'right cart id';

# set session data
$session->data( counter => 1 );
$session->flush;
$session->load;
is $session->data('counter'), 1, 'right session value';

# set cart data
$session->cart_session->data( items => ['hoge'] );
$session->flush;
$session->load;
is_deeply $session->cart_session->data('items'), ['hoge'], 'right cart value';

my $store  = $session->store;
my $result = $store->schema->resultset( $store->resultset_cart )->find($cart_id);
$result = $store->schema->resultset( $store->resultset_cart )->find($cart_id);
ok $result->data, 'schema: right cart data';

# for cart
my $cart = $session->cart_session;
is ref $cart, 'Markets::Session::CartSession', 'right cart object';

# add cart and don't save
$cart->data( payment => ['buzz'] );
$session->load;
is $cart->data('payment'), undef, 'not flush after cart data';

# add cart and save
$cart->data( payment => ['buzz'] );
$session->flush;
$session->load;
is_deeply $cart->data('payment'), ['buzz'], 'flush after load cart all data';

# get cart data
$cart->data( items => [ {} ] );
is_deeply $cart->data('items'), [ {} ], 'set data in the cart';
is_deeply $session->data('cart')->{data}->{items}, [ {} ], 'right session data changed';

# all chage cart data
$cart->data( { items => [], address => {} } );
is_deeply $cart->data, { items => [], address => {} }, 'set all cart data';
$session->flush;
$session->load;
is_deeply $cart->data, { items => [], address => {} }, 'reload cart data';

# cart data remove
$cart->flash('items');
is_deeply $cart->data, { address => {} }, 'flash instracted cart data';
$cart->flash;
is_deeply $cart->data, {}, 'flash all cart data';

$session->flush;
$session->load;
is_deeply $cart->data, {}, 'flash all cart data after reload session';

# regenerate session id
my %data    = %{ $session->data };
my $new_sid = $session->regenerate_sid;
isnt $sid, $new_sid, 'created new sid';
is $cart_id, $session->cart_id, 'don\'t create new cart_id';

my %new_data = %{ $session->data };
is %data, %new_data, 'right session data';

# change cart id
# my $new_cartid = 'aaabbbcccddd';
# $session->cart_id($new_cartid);
# is $session->cart_id, $new_cartid, 'right changed cart id';
# is $cart->cart_id, $new_cartid, 'right changed cart id';
# 
# $session->flush;
# $session->load;
# is $session->cart_id, $new_cartid, 'right changed cart id after reload';
# is $cart->cart_id, $new_cartid, 'right changed cart id after reload';

# remove session
$session->expire;
$session->flush;
is $session->load, undef, 'removed session';

done_testing();
