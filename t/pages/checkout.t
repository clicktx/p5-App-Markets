package t::pages::checkout;

use Mojo::Base 't::pages::common';
use t::Util;
use Test::More;
use Test::Deep;
use Test::Mojo;
use DDP;

my $cart_data = {
    items     => [ { product_id     => 1, quantity => 1 }, { product_id => 3, quantity => 3 } ],
    shipments => [ { shipping_items => [] } ],
};

sub startup : Test(startup) {
    my $self = shift;
    $self->SUPER::startup;

    # カートに商品を入れておく
    $self->ua->get('/');
    my $sid            = t::Util::get_sid( $self->t );
    my $server_session = t::Util::server_session( $self->app );
    $server_session->load($sid);
    $server_session->cart->data($cart_data);
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

sub test_04_address_validate : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = {
        csrf_token       => $self->csrf_token,
        billing_address  => 'Silicon Valley',
        shipping_address => 'San Francisco',
    };
    $t->post_ok( '/checkout/address', form => $post_data )->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, '/checkout/address', 'right post to get';

    my $cart = $self->server_session->cart;
    is $cart->data('billing_address'), 'Silicon Valley', '';
    is $cart->data('shipments')->[0]->{shipping_address}, 'San Francisco', '';
}

sub test_05_shipping : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/shipping')->status_is(200);
}

sub test_06_shipping_validate : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/checkout/shipping', form => $post_data )->status_is(200);
    my ($url) = map { $_->req->url->path } @{ $t->tx->redirects };
    is $url, '/checkout/shipping', 'right post to get';

    my $cart = $self->server_session->cart;
    is_deeply $cart->data('shipments')->[0]->{shipping_items}, $cart_data->{items}, 'right moved items';
}

sub test_10_confirm : Tests() {
    my $self = shift;
    my $t    = $self->t;

    $t->get_ok('/checkout/confirm')->status_is(200);
}

sub test_11_complete_validate : Tests() {
    my $self = shift;
    my $t    = $self->t;

    my $post_data = { csrf_token => $self->csrf_token, };
    $t->post_ok( '/checkout/complete', form => $post_data )->status_is(200);

    # NOTE: もっとスマートにテストを書きたい
    # Entity order objectを使うとか
    my $last_order = $self->app->schema->resultset('Order')->search( {}, { order_by => { -desc => 'id' } } )->first;
    is $last_order->billing_address, 'Silicon Valley', 'right billing address';

    my $shipment1 = $last_order->shipments->first;
    is $shipment1->shipping_address, 'San Francisco', 'right shipping address';

    my $items = $shipment1->shipping_items;
    my $row   = $items->next;
    is $row->product_id, 1, 'right item1 product id';
    is $row->quantity,   1, 'right item1 quantity';
    $row = $items->next;
    is $row->product_id, 3, 'right item2 product id';
    is $row->quantity,   3, 'right item2 quantity';
}

__PACKAGE__->runtests;
