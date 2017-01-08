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
    store         => Markets::Session::Store::Teng->new( db => $app->db ),
    transport     => MojoX::Session::Transport::Cookie->new,
    expires_delta => 3600,
);

# create session
my $sid = $session->create;
ok $sid, 'created session';
is_deeply $session->data('cart'), {}, 'cart data is empty hash after create';
$session->flush;
is_deeply $session->data('cart'), {}, 'cart data is empty hash after flush';
my $cart_id = $session->cart_id;
ok $cart_id, 'right session->cart_id';
my $store = $session->store;
my $result = $store->db->single( $store->table_cart, { cart_id => $cart_id } );
is $result->data, '', 'db: cart data is empty';
is $session->data('cart_checksum'), '', 'right checksum create after';

# load session
$cookie = Mojo::Cookie::Request->new( name => 'sid', value => $sid, path => '/' );
$tx = Mojo::Transaction::HTTP->new();
$session->tx($tx);
$tx->req->cookies($cookie);
is $session->load, $sid, 'loading session';
is_deeply $session->data('cart'), {}, 'cart data is empty hash after load';
is $session->data('cart_checksum'), '', 'right checksum load after';

# set data
$session->data( counter => 1 );
$session->data( cart => { items => [] } );
$session->flush;
$session->load;
is $session->data('counter'), 1, 'right session value';
is_deeply $session->data('cart'), { items => [] }, 'right cart value';
$result = $store->db->single( $store->table_cart, { cart_id => $cart_id } );
ok $result->data, 'db: right cart data';
ok $session->data('cart_checksum'), 'right checksum set cart data after';

# for cart
my $cart = $session->cart;
is ref $cart, 'Markets::Session::Cart', 'right cart object';

# add cart and don't save
$cart->data( payment => [] );
$session->load;
is_deeply $cart->data, { items => [] }, 'not flush after cart data';

# add cart and save
$cart->data( payment => [] );
$session->flush;
$session->load;
is_deeply $cart->data, { items => [], payment => [] }, 'flush after load cart all data';
is_deeply $cart->data('items'), [], 'get instracted data in the cart';

# get cart data
$cart->data( items => [ {} ] );
is_deeply $cart->data('items'), [ {} ], 'set data in the cart';
is_deeply $session->data('cart'), { items => [ {} ], payment => [] }, 'right session data changed';

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

# cart_checksum
$session->flush;
$session->load;
is $session->data('cart_checksum'), '', 'right checksum empty cart';

# change `session` data
$session->data( foo => 1 );
$session->flush;
$session->load;
is $session->data('cart_checksum'), '', 'modified session data after checksum';

# change `cart` data
$cart->data( items => [] );
is $session->data('cart_checksum'), '', 'modified cart data after checksum';
$session->flush;
$session->load;
ok $session->data('cart_checksum'), 'modified cart data after checksum';

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
