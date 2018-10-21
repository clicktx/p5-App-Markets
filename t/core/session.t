use Mojo::Base -strict;

use t::Util;
use Test::More;
use Test::Mojo;

my $t   = Test::Mojo->new('App');
my $app = $t->app;

my $session = t::Util::server_session($app);
my $sid     = $session->create;
my $cart_id = $session->cart_id;
my $cart    = $session->cart_session;

subtest 'create session' => sub {
    isa_ok $session, 'Yetie::App::Core::Session::ServerSession', 'right session object';
    isa_ok $cart,    'Yetie::App::Core::Session::CartSession',   'right cart object';
    isa_ok $session->cart, 'Yetie::App::Core::Session::CartSession', 'right alias';

    ok $sid, 'created session';
    is_deeply $session->cart_session->data, {}, 'create new cart';
    $session->flush;

    is_deeply $session->cart_session->data, {}, 'cart data after flush';
    ok $cart_id, 'right session->cart_id';
    is $cart_id, $session->cart_session->cart_id, 'right cart_id';
    is $session->cart_session->cart_id, $session->cart_id, 'right cart_id';

    subtest 'argument cart_id' => sub {
        my $session = t::Util::server_session($app);
        my $sid = $session->create( { cart_id => 111 } );
        is $session->cart_id, 111, 'right cart_id';
    };
};

subtest 'store for cart' => sub {
    my $store  = $session->store;
    my $result = $store->schema->resultset( $store->resultset_cart )->find($cart_id);
    $result = $store->schema->resultset( $store->resultset_cart )->find($cart_id);
    ok $result->data, 'schema: right cart data';
};

subtest 'load session' => sub {
    my $cookie = Mojo::Cookie::Request->new( name => 'sid', value => $sid, path => '/' );
    my $tx = Mojo::Transaction::HTTP->new();
    $session->tx($tx);
    $tx->req->cookies($cookie);
    is $session->load, $sid, 'loading session';
    is ref $session->cart_session->data, 'HASH', 'right cart data';
    is $session->cart_session->cart_id, $cart_id, 'right cart_id';
};

subtest 'set session data' => sub {

    # set and unsaved
    $session->data( counter => 1 );
    $session->load;
    is $session->data('counter'), undef, 'right unsaved session data';

    # set and saved
    $session->data( counter => 1 );
    $session->flush;
    $session->load;
    is $session->data('counter'), 1, 'right saved session data';
};

subtest 'set cart data' => sub {

    # set and unsaved
    $cart->data( payment => ['buzz'] );
    $session->load;
    is $cart->data('payment'), undef, 'right unsaved cart data';

    # set and saved
    $session->cart_session->data( items => ['hoge'] );
    $session->flush;
    $session->load;
    is_deeply $session->cart_session->data('items'), ['hoge'], 'right saved cart data';

    $cart->data( payment => ['buzz'] );
    $session->flush;
    $session->load;
    is_deeply $cart->data('payment'), ['buzz'], 'right saved cart data';
};

subtest 'get cart data' => sub {
    $cart->data( items => [ {} ] );
    is_deeply $cart->data('items'),                    [ {} ], 'set data in the cart';
    is_deeply $session->data('cart')->{data}->{items}, [ {} ], 'right session data changed';
    $session->flush;
    $session->load;

    is_deeply $session->store->load_cart_data($cart_id), $cart->data, 'right cart data from DB';
    is $session->store->load_cart_data('cart_id_hoge'), undef, 'right cart data not found cart';
};

subtest 'change all cart data' => sub {
    $cart->data( { items => [], address => {} } );
    is_deeply $cart->data, { items => [], address => {} }, 'set all cart data';
    $session->flush;
    $session->load;
    is_deeply $cart->data, { items => [], address => {} }, 'reload cart data';
};

subtest 'remove cart data' => sub {
    $cart->flash('items');
    is_deeply $cart->data, { address => {} }, 'flash instracted cart data';
    $cart->flash;
    is_deeply $cart->data, {}, 'flash all cart data';

    $session->flush;
    $session->load;
    is_deeply $cart->data, {}, 'flash all cart data after reload session';
};

subtest 'customer_id' => sub {
    my $customer_id = $session->data('customer_id');
    is $session->customer_id, $customer_id, 'right load customer_id';

    $session->customer_id('123456');
    is $session->customer_id, 123456, 'right changed customer_id';

    $session->flush;
    $session->load;
    is $session->customer_id, 123456, 'right changed customer_id';
};

subtest 'staff_id' => sub {
    my $staff_id = $session->data('staff_id');
    is $session->staff_id, $staff_id, 'right load staff_id';

    $session->staff_id('123456');
    is $session->staff_id, 123456, 'right changed staff_id';

    $session->flush;
    $session->load;
    is $session->staff_id, 123456, 'right changed staff_id';
};

subtest 'regenerate sid' => sub {
    my $sid     = $session->sid;
    my $cart_id = $session->cart_id;
    my %data    = %{ $session->data };
    my $new_sid = $session->regenerate_sid;
    isnt $sid, $new_sid, 'right regenerate sid';
    is $cart_id, $session->cart_id, 'right cart_id';

    my %new_data = %{ $session->data };
    is %data, %new_data, 'right session data';
    is $session->sid, $new_sid, 'right sid';

    $session->flush;
    $session->load($new_sid);
    is $session->sid, $new_sid, 'right reload sid';
    is %new_data, %{ $session->data }, 'right reload data';

    subtest 'remove session' => sub {
        $session->expire;
        $session->flush;
        is $session->load($new_sid), undef, 'removed session';
    };

    subtest 'remove cart' => sub {
        ok $session->remove_cart('not_found_cart') == 0, 'do not removed cart';
        is $session->remove_cart($cart_id), 1, 'removed cart';
    };
};

subtest 'cart is_modified' => sub {
    my $session = t::Util::server_session($app);
    $session->create;

    my $cart = $session->cart_session;
    is $cart->is_modified, 0, 'right cat not modify';

    $cart->is_modified(1);
    is $cart->is_modified, 1, 'right cart modified';
};

subtest 'remove_session' => sub {
    my $session = t::Util::server_session($app);
    $session->create;
    $session->flush;

    is $session->remove_session, 1, 'right remove session';
    is $session->remove_session, 0, 'right do not remove session';
};

done_testing();
