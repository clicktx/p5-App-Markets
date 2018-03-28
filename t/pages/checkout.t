package t::pages::checkout;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Deep;
use Test::Mojo;
use DDP;

my $CART_DATA = {
    items => [
        { product_id => 2, quantity => 2, price => 200 },
        { product_id => 1, quantity => 1, price => 100 },
        { product_id => 3, quantity => 3, price => 300 },
    ],
    shipments => [ { items => [] } ],
};

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    # カートに商品を入れておく
    $self->ua->get('/');
    my $sid            = t::Util::get_sid( $self->t );
    my $server_session = t::Util::server_session( $self->app );
    $server_session->load($sid);
    $server_session->cart->data($CART_DATA);
    $server_session->flush;
}

sub test_01_index : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout')->status_is(200);
}

sub test_02_index_post : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/checkout', form => $post_data )->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, '/checkout', 'right post to get';
}

sub test_03_address : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/address')->status_is(200);
}

sub test_04_address_post : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = {
        csrf_token                           => $self->csrf_token,
        'billing_address.personal_name'      => 'ken',
        'billing_address.line1'              => 'foo 2325',
        'billing_address.level2'             => 'bar',
        'billing_address.level1'             => 'CA',
        'billing_address.postal_code'        => '55555',
        'billing_address.phone'              => '012345678',
        'shipments.0.shipping_address.line1' => 'baz',
    };
    $t->post_ok( '/checkout/address', form => $post_data )->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, '/checkout/address', 'right post to get';

    # Reload session
    $self->server_session->load( $self->sid );

    my $cart = $self->server_session->cart;
    is $cart->data('billing_address')->{personal_name}, 'ken',       'right personal name';
    is $cart->data('billing_address')->{line1},         'foo 2325',  'right line1';
    is $cart->data('billing_address')->{level2},        'bar',       'right level2';
    is $cart->data('billing_address')->{level1},        'CA',        'right level1';
    is $cart->data('billing_address')->{postal_code},   '55555',     'right postal code';
    is $cart->data('billing_address')->{phone},         '012345678', 'right phone';
    is $cart->data('shipments')->[0]->{shipping_address}->{line1}, 'baz', 'right line1';
}

sub test_05_shipping : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/shipping')->status_is(200);
}

sub test_06_shipping_post : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/checkout/shipping', form => $post_data )->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, '/checkout/shipping', 'right post to get';

    # Reload session
    $self->server_session->load( $self->sid );

    my $cart = $self->server_session->cart;
    is_deeply $cart->data('shipments')->[0]->{items}, $CART_DATA->{items}, 'right moved items';
}

sub test_10_confirm : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/confirm')->status_is(200);
}

sub test_20_complete : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/checkout/confirm', form => $post_data )->status_is(200);

    # NOTE: もっとスマートにテストを書きたい
    # Entity order objectを使うとか
    my $last_order =
      $self->app->schema->resultset('Sales')->search( {}, { order_by => { -desc => 'id' } } )->first;
    is $last_order->billing_address->personal_name, 'ken',       'right billing address personal name';
    is $last_order->billing_address->line1,         'foo 2325',  'right billing address line1';
    is $last_order->billing_address->level2,        'bar',       'right billing address level2';
    is $last_order->billing_address->level1,        'CA',        'right billing address level1';
    is $last_order->billing_address->postal_code,   '55555',     'right billing address postal code';
    is $last_order->billing_address->phone,         '012345678', 'right billing address phone';

    my $shipment1 = $last_order->orders->first;
    is $shipment1->shipping_address->line1, 'baz', 'right shipping address';

    my $items = $shipment1->items;
    my $row   = $items->next;
    is $row->product_id, 2, 'right item1 product id';
    is $row->quantity,   2, 'right item1 quantity';
    $row = $items->next;
    is $row->product_id, 1, 'right item1 product id';
    is $row->quantity,   1, 'right item1 quantity';
    $row = $items->next;
    is $row->product_id, 3, 'right item3 product id';
    is $row->quantity,   3, 'right item3 quantity';
}

__PACKAGE__->runtests;
